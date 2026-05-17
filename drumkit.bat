@echo off
:: Launcher for Windows: activates the local venv and runs drumkit.py
:: Paths are relative to this script's own directory — no hardcoded paths.
set SCRIPT_DIR=%~dp0
"%SCRIPT_DIR%.venv\Scripts\python.exe" "%SCRIPT_DIR%drumkit.py" %*
