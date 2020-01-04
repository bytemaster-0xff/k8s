Need to publish app

dotnet restore
dotnet publish -o ./publish

Notes on building docker images, need to look at Docker Compose, but for now...
https://dev.to/schwamster/docker-tutorial-with-for-aspnet-core

Dockerfile (no extension)
FROM microsoft/aspnetcore
WORKDIR /app
COPY ./publish .
ENTRYPOINT ["dotnet", "EntryPoint.dll"]

docker build -t [CONTAINERNAME] .

Running 
=================================
docker run -p 5000:80 -p=6000-6100:6000-6100 -e HostId='69749BB7AE984D70AEB89455BA23D0AE'  [ORGNAME]/[ContainerName]


Publishing
=================================
docker login
docker tag docker-tutorial [ORGNAME]/[ContainerName]

docker push [ORGNAME]/[ContainerName]




Notes on Getting IoT Engine up in Docker
===================================================================
===================================================================

Replace host id with value created on server.

Setup SSH Private key from... and use the uid of root...passpharse is really tough one.


Instructions on setting up docker on runtime instance (only do once, can we create templates?)
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

apt-cache policy docker-ce

See this output
docker-ce:
  Installed: (none)
  Candidate: 17.03.1~ce-0~ubuntu-xenial
  Version table:
     17.03.1~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages



sudo apt-get install -y docker-ce

Check Status
sudo systemctl status docker

Start Instance, mapping admin port on port 5000 and mapping ports 6000-6100 to internet
docker run -p 5000:80 -p=6000-6100:6000-6100 -e HostId='69749BB7AE984D70AEB89455BA23D0AE'  nuviot/sharedhost

https://dev.nuviot.com/api/deployment/host/EF01AC197F294128916C19C909C3D576



Add Node
