# Stage 1: Build the .NET web application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the .csproj and restore the dependencies
COPY WebApplication1/*.csproj ./WebApplication1/
RUN dotnet restore "WebApplication1/WebApplication1.csproj"

# Copy the rest of the application code and build it
COPY WebApplication1/. ./WebApplication1/
WORKDIR "/src/WebApplication1"
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
EXPOSE 80

# Copy the built application from the build stage
COPY --from=build /app/publish .

# Start the .NET Core web application
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
