const mode = process.env.BUILD_MODE ?? "standalone";
console.log("[Next] build mode", mode);

/** @type {import('next').NextConfig} */
const nextConfig = {
  webpack(config) {
    config.resolve.fallback = {
      child_process: false,
    };

    return config;
  },
  output: mode,
  experimental: {
    forceSwcTransforms: true,
  },
};

export default nextConfig;
