# First stage of multi-stage build
#FROM microsoft/aspnetcore-build AS build-env
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build-env
WORKDIR /app

# copy the contents of agent working directory on host to workdir in container
COPY . ./

# dotnet commands to build, test, and publish
RUN dotnet restore
RUN dotnet build -c Release
RUN dotnet publish -c Release -o out

# Second stage - Build runtime image
#FROM microsoft/aspnetcore
FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "pipelines-dotnet-core-docker.dll"]
