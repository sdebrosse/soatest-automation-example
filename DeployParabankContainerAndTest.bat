:: Set variables
set LOCALSETTINGS_PATH=C:\Users\sdebrosse\Desktop\localsettings.properties
set TEMP_WORKSPACE_PATH=C:\Users\sdebrosse\parasoft\temp_workspace

:: In this section, we first shut down all running container instances of Parabank to ensure our environment is clean.
:: Then we pull the latest Parabank image from Dockerhub and deploy it at port 5080.
FOR /f "tokens=*" %%i IN ('docker ps -a -q --filter^=ancestor^=parasoft/parabank') DO docker rm -f %%i
docker pull parasoft/parabank
docker run -d -p 5080:8080 parasoft/parabank
sleep 10

:: In this section, we execute SOAtest. The first line creates the workspace called “temp_workspace” and then imports the Parabank project into this workspace. This is a required first step before executing the tests inside the Parabank project.
:: The second line executes all .tst files inside the Parabank project.

soatestcli.exe -data %TEMP_WORKSPACE_PATH% -import C:\Users\sdebrosse\parasoft\soavirt_workspace\Parabank
soatestcli.exe -data %TEMP_WORKSPACE_PATH% -resource /Parabank -config "builtin://Demo Configuration" -localsettings %LOCALSETTINGS_PATH%

:: Clean up section. Shuts down all running container instances of the “parasoft/parabank” image. The second line deletes the temp_workspace
FOR /f "tokens=*" %%i IN ('docker ps -a -q --filter^=ancestor^=parasoft/parabank') DO docker rm -f %%i
rmdir /Q /S %TEMP_WORKSPACE_PATH%
