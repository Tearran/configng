# DEPRECATION NOTICE: module_network_simple.sh is deprecated and will be removed in a future release.
# Please migrate to the new module_network_simple_refactored.sh and network_simple_helpers.sh.

# Source the refactored implementation which provides the full command logic and re-registers the same network_options entries.
source "${BASH_SOURCE%/*}/module_network_simple_refactored.sh"

function module_simple_network() {
    echo "Warning: module_simple_network is deprecated; delegating to module_simple_network_refactored" >&2
    module_simple_network_refactored "$@"
    return $?
}
