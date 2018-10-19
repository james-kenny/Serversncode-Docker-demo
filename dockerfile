FROM microsoft/dotnet:2.1.402-sdk-alpine3.7 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ServersncodeDemo.Web/*.*.csproj ./ServersncodeDemo.Web/
COPY ServersncodeDemo.Data/*.*.csproj ./ServersncodeDemo.Data/
RUN dotnet restore

# copy everything else and build app
COPY ServersncodeDemo.Web/. ./ServersncodeDemo.Web/
COPY ServersncodeDemo.Data/. ./ServersncodeDemo.Data/
WORKDIR /app/ServersncodeDemo.Web
RUN dotnet publish -c Release -o out

FROM microsoft/dotnet:2.1.4-aspnetcore-runtime-alpine3.7  AS runtime
WORKDIR /app
COPY --from=build /app/ServersncodeDemo.Web/out ./
ENTRYPOINT ["dotnet", "ServersncodeDemo.Web.dll"]