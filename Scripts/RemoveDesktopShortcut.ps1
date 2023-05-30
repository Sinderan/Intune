$Program = "" ##Beginning of Desktop Shortcut Name with optional Wildcard e.g. "R *" for "R 3.4.0"

function Sync-Explorer { 
    $code = @' 
private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);  
private const int WM_SETTINGCHANGE = 0x1a;  
private const int SMTO_ABORTIFHUNG = 0x0002;  
 
 
[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)] 
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, UIntPtr wParam, 
   IntPtr lParam); 
 
[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]  
  private static extern IntPtr SendMessageTimeout ( IntPtr hWnd, int Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, IntPtr lpdwResult );  
 
 
[System.Runtime.InteropServices.DllImport("Shell32.dll")]  
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2); 
 
 
public static void Refresh()  { 
    SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero); 
    SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);  
} 
'@ 
 
    Add-Type -MemberDefinition $code -Namespace MyWinAPI -Name Explorer  
    [MyWinAPI.Explorer]::Refresh() 
}

$PublicDesktopPath = [Environment]::GetFolderPath("CommonDesktopDirectory")
$UserDesktopPath = [Environment]::GetFolderPath("Desktop")
$PublicShortcutPath = Resolve-Path "$PublicDesktopPath\$Program.lnk" -ErrorAction SilentlyContinue -ErrorVariable _frperror
$UserShortcutPath = Resolve-Path "$UserDesktopPath\$Program.lnk" -ErrorAction SilentlyContinue -ErrorVariable _frperror
if (-not($PublicShortcutPath)) {
    $PublicShortcutPath = $_frperror[0].TargetObject
}
if (-not($UserShortcutPath)) {
    $UserShortcutPath = $_frperror[0].TargetObject
}

Write-Output $PublicShortcutPath
If (Test-Path $PublicShortcutPath) {
    Write-Output 'Removing Desktop Shortcut'
    Remove-Item $PublicShortcutPath
    Sync-Explorer
} Else {
    Write-Output 'Desktop Shortcut Not Found'
}
Write-Output $UserShortcutPath
If (Test-Path $UserShortcutPath) {
    Write-Output 'Removing Desktop Shortcut'
    Remove-Item $UserShortcutPath
    Sync-Explorer
} Else {
    Write-Output 'Desktop Shortcut Not Found'
}