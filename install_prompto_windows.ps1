docker-compose version 2> $null
$version=$?
If($version)
{
  # read folder to mount for logs and mongo files
  $PROMPTO_DATA = $HOME + "\prompto-data"
  $USER_INPUT = Read-Host -Prompt "enter the folder where prompto will store its data (return for default: ${PROMPTO_DATA})" 
  If($USER_INPUT -eq "")
  {
    $USER_INPUT=$PROMPTO_DATA
  }
  $PROMPTO_DATA=$USER_INPUT
  mkdir $PROMPTO_DATA 2>&1>$null
  echo "prompto will store its data in folder $PROMPTO_DATA"
  $USER_INPUT = ""

  # read port to connect to mongo
  $MONGO_PORT = 27017
  $USER_INPUT = Read-Host -Prompt "enter the tcp port to use for connecting to the Mongo database (return for default: ${MONGO_PORT})"
  If($USER_INPUT -eq "")
  {
    $USER_INPUT=$MONGO_PORT
  }
  $MONGO_PORT = $USER_INPUT
  echo "Mongo database will be accessible at localhost:$MONGO_PORT"
  $USER_INPUT = ""

  # read port to connect to factory
  $FACTORY_PORT = 80
  $USER_INPUT = Read-Host -Prompt "enter the http port to use for the prompto factory UI (return for default: ${FACTORY_PORT})"
  If($USER_INPUT -eq "")
  {
    $USER_INPUT=$FACTORY_PORT
  } 
  $FACTORY_PORT = $USER_INPUT
  echo "prompto will be accessible at http://localhost:$FACTORY_PORT"
  $USER_INPUT = ""

  # read port to connect to webapp
  $DEVELOPER_PORT = 8000
  $USER_INPUT = Read-Host -Prompt "enter the http port to use by your app (return for default: ${DEVELOPER_PORT})"
  If($USER_INPUT -eq "")
  {
    $USER_INPUT=$DEVELOPER_PORT
  } 
  $DEVELOPER_PORT = $USER_INPUT
  echo "your app will be accessible at http://localhost:$DEVELOPER_PORT"
  $USER_INPUT = ""

  # read factory version
  echo "reading latest prompto factory version"
  $FACTORY_VERSION = ((curl.exe -s https://api.github.com/repos/prompto/prompto-factory/releases/latest | Select-String -Pattern tag_name) -Split ":")[1].Trim(" ,").Trim([char]0x0022).Trim("v")
  echo "found factory version $FACTORY_VERSION"

  echo "downloading prompto for docker"
  curl.exe -s https://raw.githubusercontent.com/prompto/prompto-docker/master/docker-compose.yml >> "$PROMPTO_DATA\docker-compose.yml"

  echo "installing prompto for docker at $PROMPTO_DATA"
  pushd $PROMPTO_DATA
    If(Test-Path .env)
    {
      Remove-Item .env
    }
    echo "PROMPTO_DATA=$PROMPTO_DATA" | out-file -encoding ASCII .env
    echo "MONGO_PORT=$MONGO_PORT" | out-file -append -encoding ASCII .env
    echo "FACTORY_PORT=$FACTORY_PORT" | out-file -append -encoding ASCII .env
    echo "DEVELOPER_PORT=$DEVELOPER_PORT" | out-file -append -encoding ASCII .env
    echo "FACTORY_IMAGE=prompto/factory:$FACTORY_VERSION" | out-file -append -encoding ASCII .env
    if(Test-Path start-prompto.bat)
    {
      Remove-Item start-prompto.bat
    }
    echo "docker compose up --detach" | out-file -encoding ASCII start-prompto.bat
    echo 'echo "sleeping 10s while prompto is starting"' | out-file -append -encoding ASCII start-prompto.bat
    echo 'powershell -nop -c "& {sleep 10}"' | out-file -append -encoding ASCII start-prompto.bat
    echo "cmd /c start http://localhost:$FACTORY_PORT" | out-file -append -encoding ASCII start-prompto.bat
    docker compose up --no-start
  popd 

  echo "prompto for docker installed at $PROMPTO_DATA"
  echo "to start prompto, open terminal and type:"
  echo "  cd $PROMPTO_DATA"
  echo "  start-prompto"
  echo "to stop prompto, open terminal and type:"
  echo "  cd $PROMPTO_DATA"
  echo "  docker-compose stop"

  echo "starting prompto..."
  pushd $PROMPTO_DATA
    Start-Process start-prompto.bat
  popd

} 
else
{
  echo "it seems you do not have docker-compose installed, please install docker-compose and retry"
}