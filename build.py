import os
import shutil

# WARNING!!! This is not production ready. It is to temporarily unlock the team to working on the MVP

PRE_REQ = ['PromiseKit']
SCHEMES = ['VCCrypto', 'VCEntities', 'VCNetworking', 'VCSamples', 'VCServices', 'VCToken']
WORKSPACE = 'sdk.xcworkspace'
CONFIG = 'Debug'
VARIANTS = {
    'iphoneos': 'arm64',
    'iphonesimulator': 'x86_64'
}
DERIVED_DATA_PATH = './DerivedData'
SIMULATOR_PRODUCT_PATH = './DerivedData/Build/Products/Debug-iphonesimulator'
DEVICE_PRODUCT_PATH = './DerivedData/Build/Products/Debug-iphoneos'

OUTPUT_FOLDER = './Distribution'
PODSPEC_NAME = 'VerifiableCredential-SDK-iOS.podspec'
PODSPEC_TEMPLATE = """
Pod::Spec.new do |s|
    s.name = "VerifiableCredential-SDK-iOS"
    s.platform = :ios, "11.0"
    s.version = "1.0.0"
    s.author = "Microsoft"
    s.homepage = "https://github.com/microsoft/VerifiableCredential-SDK-iOS"
    s.summary = "SDK to interact with verifiable credentials and Decentralized Identifiers (DIDs) on the ION network"
    s.description = "This SDK is used in the Microsoft Authenticator app in order to interact with verifiable credentials and Decentralized Identifiers (DIDs) on the ION network. It can be integrated with any app to provide interactions using verifiable credentials."
    s.requires_arc = true
    s.license = 'MIT'
    s.source   = { :git => 'https://github.com/microsoft/VerifiableCredential-SDK-iOS.git', :tag => s.version }
    s.vendored_frameworks = <frameworks>
end
"""

# compile all variants
for scheme in PRE_REQ + SCHEMES:
    for sdk, arch in VARIANTS.items():
        command = [
            'xcrun',
            'xcodebuild',
            '-workspace',
            WORKSPACE,
            '-scheme',
            scheme,
            '-sdk',
            sdk,
            '-arch',
            arch,
            '-derivedDataPath',
            DERIVED_DATA_PATH,
            'CODE_SIGN_IDENTITY=""',
            'CODE_SIGNING_REQUIRED=NO'
        ]
        os.system(' '.join(command))

shutil.rmtree(OUTPUT_FOLDER, ignore_errors=True)
os.mkdir(OUTPUT_FOLDER)

# merge universal binaries
for scheme in SCHEMES:
    framework_name = f"{scheme}.framework"
    sim_variant_path = f"{SIMULATOR_PRODUCT_PATH}/{framework_name}"
    device_variant_path = f"{DEVICE_PRODUCT_PATH}/{framework_name}"
    output_path = f"{OUTPUT_FOLDER}/{framework_name}"
    # copy debug to output
    shutil.copytree(sim_variant_path, output_path)
    # merge binaries
    os.system(f"xcrun lipo -create -o {output_path}/{scheme} {sim_variant_path}/{scheme} {device_variant_path}/{scheme}")
# write podspec
with open(f"{OUTPUT_FOLDER}/{PODSPEC_NAME}", 'w') as f:
    frameworks = ", ".join(map(lambda s: f"'{s}.framework'", SCHEMES))
    f.write(PODSPEC_TEMPLATE.replace('<frameworks>', frameworks))



