#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR


# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")


variant_for_slice()
{
  case "$1" in
  "Apptics.xcframework/ios-arm64")
    echo ""
    ;;
  "Apptics.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "Apptics.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "Apptics.xcframework/macos-arm64_x86_64")
    echo ""
    ;;
  "Apptics.xcframework/tvos-arm64")
    echo ""
    ;;
  "Apptics.xcframework/tvos-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "Apptics.xcframework/watchos-arm64_arm64_32_armv7k")
    echo ""
    ;;
  "Apptics.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsCrashKit.xcframework/ios-arm64")
    echo ""
    ;;
  "AppticsCrashKit.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "AppticsCrashKit.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsCrashKit.xcframework/macos-arm64_x86_64")
    echo ""
    ;;
  "AppticsCrashKit.xcframework/tvos-arm64")
    echo ""
    ;;
  "AppticsCrashKit.xcframework/tvos-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsCrashKit.xcframework/watchos-arm64_arm64_32_armv7k")
    echo ""
    ;;
  "AppticsCrashKit.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsEventTracker.xcframework/ios-arm64")
    echo ""
    ;;
  "AppticsEventTracker.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "AppticsEventTracker.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsEventTracker.xcframework/macos-arm64_x86_64")
    echo ""
    ;;
  "AppticsEventTracker.xcframework/tvos-arm64")
    echo ""
    ;;
  "AppticsEventTracker.xcframework/tvos-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsEventTracker.xcframework/watchos-arm64_arm64_32_armv7k")
    echo ""
    ;;
  "AppticsEventTracker.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "simulator"
    ;;
  "JWT.xcframework/ios-arm64")
    echo ""
    ;;
  "JWT.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "JWT.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "JWT.xcframework/macos-arm64_x86_64")
    echo ""
    ;;
  "JWT.xcframework/tvos-arm64")
    echo ""
    ;;
  "JWT.xcframework/tvos-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "JWT.xcframework/watchos-arm64_arm64_32_armv7k")
    echo ""
    ;;
  "JWT.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "simulator"
    ;;
  "KSCrash.xcframework/ios-arm64")
    echo ""
    ;;
  "KSCrash.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "KSCrash.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "KSCrash.xcframework/macos-arm64_x86_64")
    echo ""
    ;;
  "KSCrash.xcframework/tvos-arm64")
    echo ""
    ;;
  "KSCrash.xcframework/tvos-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "KSCrash.xcframework/watchos-arm64_arm64_32_armv7k")
    echo ""
    ;;
  "KSCrash.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsScreenTracker.xcframework/ios-arm64")
    echo ""
    ;;
  "AppticsScreenTracker.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "AppticsScreenTracker.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsScreenTracker.xcframework/macos-arm64_x86_64")
    echo ""
    ;;
  "AppticsScreenTracker.xcframework/tvos-arm64")
    echo ""
    ;;
  "AppticsScreenTracker.xcframework/tvos-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AppticsScreenTracker.xcframework/watchos-arm64_arm64_32_armv7k")
    echo ""
    ;;
  "AppticsScreenTracker.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "simulator"
    ;;
  esac
}

archs_for_slice()
{
  case "$1" in
  "Apptics.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "Apptics.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "arm64 x86_64"
    ;;
  "Apptics.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "Apptics.xcframework/macos-arm64_x86_64")
    echo "arm64 x86_64"
    ;;
  "Apptics.xcframework/tvos-arm64")
    echo "arm64"
    ;;
  "Apptics.xcframework/tvos-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "Apptics.xcframework/watchos-arm64_arm64_32_armv7k")
    echo "arm64 arm64_32 armv7k"
    ;;
  "Apptics.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "arm64 i386 x86_64"
    ;;
  "AppticsCrashKit.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "AppticsCrashKit.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "arm64 x86_64"
    ;;
  "AppticsCrashKit.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AppticsCrashKit.xcframework/macos-arm64_x86_64")
    echo "arm64 x86_64"
    ;;
  "AppticsCrashKit.xcframework/tvos-arm64")
    echo "arm64"
    ;;
  "AppticsCrashKit.xcframework/tvos-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AppticsCrashKit.xcframework/watchos-arm64_arm64_32_armv7k")
    echo "arm64 arm64_32 armv7k"
    ;;
  "AppticsCrashKit.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "arm64 i386 x86_64"
    ;;
  "AppticsEventTracker.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "AppticsEventTracker.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "arm64 x86_64"
    ;;
  "AppticsEventTracker.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AppticsEventTracker.xcframework/macos-arm64_x86_64")
    echo "arm64 x86_64"
    ;;
  "AppticsEventTracker.xcframework/tvos-arm64")
    echo "arm64"
    ;;
  "AppticsEventTracker.xcframework/tvos-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AppticsEventTracker.xcframework/watchos-arm64_arm64_32_armv7k")
    echo "arm64 arm64_32 armv7k"
    ;;
  "AppticsEventTracker.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "arm64 i386 x86_64"
    ;;
  "JWT.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "JWT.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "arm64 x86_64"
    ;;
  "JWT.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "JWT.xcframework/macos-arm64_x86_64")
    echo "arm64 x86_64"
    ;;
  "JWT.xcframework/tvos-arm64")
    echo "arm64"
    ;;
  "JWT.xcframework/tvos-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "JWT.xcframework/watchos-arm64_arm64_32_armv7k")
    echo "arm64 arm64_32 armv7k"
    ;;
  "JWT.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "arm64 i386 x86_64"
    ;;
  "KSCrash.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "KSCrash.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "arm64 x86_64"
    ;;
  "KSCrash.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "KSCrash.xcframework/macos-arm64_x86_64")
    echo "arm64 x86_64"
    ;;
  "KSCrash.xcframework/tvos-arm64")
    echo "arm64"
    ;;
  "KSCrash.xcframework/tvos-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "KSCrash.xcframework/watchos-arm64_arm64_32_armv7k")
    echo "arm64 arm64_32 armv7k"
    ;;
  "KSCrash.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "arm64 i386 x86_64"
    ;;
  "AppticsScreenTracker.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "AppticsScreenTracker.xcframework/ios-arm64_x86_64-maccatalyst")
    echo "arm64 x86_64"
    ;;
  "AppticsScreenTracker.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AppticsScreenTracker.xcframework/macos-arm64_x86_64")
    echo "arm64 x86_64"
    ;;
  "AppticsScreenTracker.xcframework/tvos-arm64")
    echo "arm64"
    ;;
  "AppticsScreenTracker.xcframework/tvos-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AppticsScreenTracker.xcframework/watchos-arm64_arm64_32_armv7k")
    echo "arm64 arm64_32 armv7k"
    ;;
  "AppticsScreenTracker.xcframework/watchos-arm64_i386_x86_64-simulator")
    echo "arm64 i386 x86_64"
    ;;
  esac
}

copy_dir()
{
  local source="$1"
  local destination="$2"

  # Use filter instead of exclude so missing patterns don't throw errors.
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" \"${source}*\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" "${source}"/* "${destination}"
}

SELECT_SLICE_RETVAL=""

select_slice() {
  local xcframework_name="$1"
  xcframework_name="${xcframework_name##*/}"
  local paths=("${@:2}")
  # Locate the correct slice of the .xcframework for the current architectures
  local target_path=""

  # Split archs on space so we can find a slice that has all the needed archs
  local target_archs=$(echo $ARCHS | tr " " "\n")

  local target_variant=""
  if [[ "$PLATFORM_NAME" == *"simulator" ]]; then
    target_variant="simulator"
  fi
  if [[ ! -z ${EFFECTIVE_PLATFORM_NAME+x} && "$EFFECTIVE_PLATFORM_NAME" == *"maccatalyst" ]]; then
    target_variant="maccatalyst"
  fi
  for i in ${!paths[@]}; do
    local matched_all_archs="1"
    local slice_archs="$(archs_for_slice "${xcframework_name}/${paths[$i]}")"
    local slice_variant="$(variant_for_slice "${xcframework_name}/${paths[$i]}")"
    for target_arch in $target_archs; do
      if ! [[ "${slice_variant}" == "$target_variant" ]]; then
        matched_all_archs="0"
        break
      fi

      if ! echo "${slice_archs}" | tr " " "\n" | grep -F -q -x "$target_arch"; then
        matched_all_archs="0"
        break
      fi
    done

    if [[ "$matched_all_archs" == "1" ]]; then
      # Found a matching slice
      echo "Selected xcframework slice ${paths[$i]}"
      SELECT_SLICE_RETVAL=${paths[$i]}
      break
    fi
  done
}

install_xcframework() {
  local basepath="$1"
  local name="$2"
  local package_type="$3"
  local paths=("${@:4}")

  # Locate the correct slice of the .xcframework for the current architectures
  select_slice "${basepath}" "${paths[@]}"
  local target_path="$SELECT_SLICE_RETVAL"
  if [[ -z "$target_path" ]]; then
    echo "warning: [CP] $(basename ${basepath}): Unable to find matching slice in '${paths[@]}' for the current build architectures ($ARCHS) and platform (${EFFECTIVE_PLATFORM_NAME-${PLATFORM_NAME}})."
    return
  fi
  local source="$basepath/$target_path"

  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
  fi

  copy_dir "$source/" "$destination"
  echo "Copied $source to $destination"
}

install_xcframework "${PODS_ROOT}/AppticsAnalytics/Apptics/Apptics.xcframework" "AppticsAnalytics/Apptics" "framework" "ios-arm64" "ios-arm64_x86_64-maccatalyst" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AppticsAnalytics/Apptics/AppticsCrashKit.xcframework" "AppticsAnalytics/CrashKit" "framework" "ios-arm64" "ios-arm64_x86_64-maccatalyst" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AppticsAnalytics/Apptics/AppticsEventTracker.xcframework" "AppticsAnalytics/EventTracker" "framework" "ios-arm64" "ios-arm64_x86_64-maccatalyst" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AppticsAnalytics/Apptics/JWT.xcframework" "AppticsAnalytics/JWT" "framework" "ios-arm64" "ios-arm64_x86_64-maccatalyst" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AppticsAnalytics/Apptics/KSCrash.xcframework" "AppticsAnalytics/KSCrash" "framework" "ios-arm64" "ios-arm64_x86_64-maccatalyst" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AppticsAnalytics/Apptics/AppticsScreenTracker.xcframework" "AppticsAnalytics/ScreenTracker" "framework" "ios-arm64" "ios-arm64_x86_64-maccatalyst" "ios-arm64_x86_64-simulator"

