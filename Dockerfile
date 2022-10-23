FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MiniMindMysteriesServer/MiniMindMysteriesServer.csproj", "MiniMindMysteriesServer/"]
RUN dotnet restore "MiniMindMysteriesServer/MiniMindMysteriesServer.csproj"
COPY . .
WORKDIR "/src/MiniMindMysteriesServer"
RUN dotnet build "MiniMindMysteriesServer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MiniMindMysteriesServer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MiniMindMysteriesServer.dll"]
