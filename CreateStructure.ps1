# Define the base directory
$baseDir = "healthcare-platform"

# Define the structure
$structure = @(
    "$baseDir/backend/src/config/supabase.js",
    "$baseDir/backend/src/config/web3.js",
    "$baseDir/backend/src/controllers/auth.js",
    "$baseDir/backend/src/controllers/health.js",
    "$baseDir/backend/src/controllers/access.js",
    "$baseDir/backend/src/middleware/auth.js",
    "$baseDir/backend/src/middleware/validation.js",
    "$baseDir/backend/src/utils/ipfs.js",
    "$baseDir/backend/src/utils/fhir.js",
    "$baseDir/backend/src/app.js",
    "$baseDir/backend/.env",
    "$baseDir/backend/package.json",
    "$baseDir/smart-contracts/contracts/HealthData.sol",
    "$baseDir/smart-contracts/scripts/deploy.js",
    "$baseDir/smart-contracts/test/HealthData.test.js",
    "$baseDir/smart-contracts/hardhat.config.js",
    "$baseDir/smart-contracts/package.json",
    "$baseDir/frontend/lib/screens/auth/login.dart",
    "$baseDir/frontend/lib/screens/auth/register.dart",
    "$baseDir/frontend/lib/screens/dashboard/patient.dart",
    "$baseDir/frontend/lib/screens/dashboard/provider.dart",
    "$baseDir/frontend/lib/screens/records/view.dart",
    "$baseDir/frontend/lib/screens/records/add.dart",
    "$baseDir/frontend/lib/services/auth_service.dart",
    "$baseDir/frontend/lib/services/health_service.dart",
    "$baseDir/frontend/lib/services/blockchain_service.dart",
    "$baseDir/frontend/lib/models/user.dart",
    "$baseDir/frontend/lib/models/health_record.dart",
    "$baseDir/frontend/lib/widgets/health_card.dart",
    "$baseDir/frontend/lib/widgets/access_control.dart",
    "$baseDir/frontend/lib/main.dart",
    "$baseDir/frontend/pubspec.yaml",
    "$baseDir/frontend/assets/",
    "$baseDir/supabase/migrations/00_initial.sql",
    "$baseDir/supabase/migrations/01_access_control.sql",
    "$baseDir/README.md"
)

# Create directories and files
foreach ($path in $structure) {
    if ($path.EndsWith("/")) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    } else {
        $dir = Split-Path -Parent $path
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        New-Item -ItemType File -Path $path -Force | Out-Null
    }
}

Write-Host "File structure created successfully at $baseDir"
