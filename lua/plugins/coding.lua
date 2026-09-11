return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      fuzzy = {
        use_frecency = true,
        use_proximity = true,
        sorts = { "score", "sort_text" },
        prebuilt_binaries = {
          download = true,
          ignore_version_mismatch = false,
          force_version = nil,
          force_system_triple = nil,
          -- NOTE: for watt-toolkit hosts
          extra_curl_args = { "--ssl-no-revoke" },
        },
      },
    },
  },
}
