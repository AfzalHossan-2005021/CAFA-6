@echo off
REM Create a Python virtual environment and install requirements

python -m venv .venv
if %ERRORLEVEL% NEQ 0 (
  echo Failed to create virtual environment. Ensure Python is on PATH.
  exit /b %ERRORLEVEL%
)

call .venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt

echo.
echo Done.
echo Activate the environment with:
echo     call .venv\Scripts\activate
echo To use from Jupyter, install an ipykernel for the venv (see README.md).
