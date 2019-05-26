FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-1709

SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45

COPY Inspinia_MVC5_SeedProject Inspinia_MVC5_SeedProject
RUN Remove-WebSite -Name 'Default Web Site'
RUN New-Website -Name 'sitiouno-system' -Port 80 \
    -PhysicalPath 'c:\AspNewMvcUnitTest.Web' -ApplicationPool '.NET v4.5'
EXPOSE 80

CMD Write-Host IIS Started... ; \
    while ($true) { Start-Sleep -Seconds 3600 }