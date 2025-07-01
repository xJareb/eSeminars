FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY . .

# Build se pokreće u folderu eSeminars.Subscriber, gdje je i .csproj fajl
WORKDIR /app/eSeminars.Subscriber

RUN dotnet restore
RUN dotnet build -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/runtime:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .

ENTRYPOINT ["dotnet", "eSeminars.Subscriber.dll"]