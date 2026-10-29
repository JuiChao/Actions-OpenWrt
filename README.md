# Actions-OpenWrt for 360T7

<p align="center">
  <img src="https://img.shields.io/badge/OpenWrt-LEDE-blue.svg?style=flat-square&logo=openwrt" alt="OpenWrt">
  <img src="https://img.shields.io/badge/Device-360T7_(MT7981)-orange.svg?style=flat-square&logo=router" alt="Device">
  <img src="https://img.shields.io/badge/Build_Time-19_min-brightgreen.svg?style=flat-square&logo=githubactions" alt="Build Time">
  <img src="https://img.shields.io/badge/Release-Automated-success.svg?style=flat-square&logo=github" alt="Release">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License">
</p>

基于 [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) 源码，为 **奇虎 360T7（MediaTek MT7981B / Filogic 820）** 定制的高性能 OpenWrt 固件自动化云端构建仓库。

本项目针对 GitHub Actions 云端构建进行了全链路工业级工程优化，二次增量编译总耗时已压缩至 **19 分 33 秒**（提速 **87.8%**）。

---

## 📌 固件核心信息

| 配置项 | 默认参数 |
| :--- | :--- |
| **设备型号** | 奇虎 360T7 / MediaTek MT7981B (Filogic 820) |
| **目标架构** | `MediaTek Filogic` (`aarch64_cortex-a53`) |
| **管理地址** | `192.168.123.1` |
| **默认账户** | `root` |
| **默认密码** | `password` |
| **Wi-Fi 硬件加速** | **已启用 MTK WED (Wireless Ethernet Dispatcher) 无线满血加速补丁** |
| **Web 界面** | 预装经典现代化 **Argon** 主题及中文完整语言包 |

### 🚀 内置核心功能与插件
* **网络与内核**：MTK WED 硬件转发加速、BBR 拥塞控制、NF/NFT Socket、ZRAM 内存压缩交换（LZO-RLE）、IPv6 完整协议栈；
* **代理与路由**：PassWall（包含 Sing-box、Xray-core、Hysteria、GeoView、V2ray-Geodata、Haproxy、Tcping）；
* **异地组网**：ZeroTier 内网穿透与跨网互联。

---

## ⚡ 编译性能基准测试（Benchmark）

通过深度挖掘 GitHub Actions 免费 4 核 Runner 的极限性能，实现了全链路多级缓存加速：

| 优化阶段 | 构建总时长 | `Download` 耗时 | `Compile` 核心编译 | Ccache 命中表现 |
| :--- | :--- | :--- | :--- | :--- |
| **初始原版** | 2 小时 40 分 | ~ 6 分钟 | ~ 32 分钟 (挂起 2h) | 0% (未激活) |
| **修复环境与依赖** | 68 分 11 秒 | 5 分 51 秒 | 60 分 55 秒 | 0% (冷启动全编译) |
| **激活 Toolchain + Ccache** | 32 分 58 秒 | 4 分 20 秒 | 24 分 35 秒 | 18,086 次命中 |
| **接入 dl 源码包与 Go 缓存** | 22 分 27 秒 | 50 秒 | 17 分 10 秒 | 48,883 次命中 |
| **🔥 最终极致优化** | **19 分 33 秒** | **仅 39 秒** | **仅 15 分 04 秒** | **直接命中率 96.9%** |

> [!TIP]
> **提速核心秘诀**：
> 1. **Ccache 深度编译器缓存**：在 `diy-part2.sh` 中幂等注入 `CONFIG_DEVEL=y` 与 `CONFIG_CCACHE=y`，4.8 万+ 个 C/C++ 目标文件直接秒级提取（直接命中率达 96.9%）；
> 2. **Toolchain 交叉工具链复用**：`cachewrtbuild` 免除每次重复编译 GCC 交叉编译器与 host 基础工具的 15+ 分钟耗时；
> 3. **`openwrt/dl` 源码包持久化**：使用 `actions/cache@v6` 缓存 2GB+ 源码包与依赖，`Download package` 从 6 分钟直接压至 39 秒；
> 4. **Go 构建缓存持久化 (`GOCACHE`)**：将 Go 编译缓存纳入持久化，加速 `sing-box`、`xray`、`hysteria` 等大型 Go 项目构建；
> 5. **防御性安全隔离**：建立 `staging_dir/host/bin/ccache` 自动软链接保底，并限定 `find dl -maxdepth 1 -type f` 保护 Go 模块缓存免遭误删。

---

## 🛠️ 使用与自定义说明

### 1. 固件下载
- **GitHub Releases（推荐）**：每次构建完成后，自动将生成的固件上传到本仓库的 [Releases 页面](../../releases)，附带机型说明与校验和，自动保留最新 5 个版本；
- **Actions Artifacts**：在每次构建任务的页面下方，亦可直接下载生成的固件归档文件（保留 90 天）。

### 2. 手动触发编译
1. 进入本仓库的 **Actions** 标签页；
2. 在左侧选择 **OpenWrt-360T7-Builder** 工作流；
3. 点击右侧 **Run workflow** 下拉按钮，点击绿色按钮即可开始编译；
4. 编译完成后，前往 Releases 或 Artifacts 获取刷机包。

### 3. 自定义配置与脚本
- [.config-360t7](.config-360t7)：360T7 专用的 OpenWrt `diffconfig` 配置文件，增删插件可直接在此调整；
- [diy-part1.sh](diy-part1.sh)：在更新 Feeds 之前执行，用于添加外部插件源；
- [diy-part2.sh](diy-part2.sh)：在更新 Feeds 之后执行，用于修改默认后台 IP、应用 MTK 无线加速补丁以及注入 Ccache/GOCACHE 优化配置。

---

## 📜 致谢与开源协议

* [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) - Lean's OpenWrt Source
* [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) - Actions OpenWrt Framework
* [klever1988/cachewrtbuild](https://github.com/klever1988/cachewrtbuild) - OpenWrt Build Cache
* [actions/cache](https://github.com/actions/cache) - GitHub Actions Cache
* [softprops/action-gh-release](https://github.com/softprops/action-gh-release) - GitHub Releases Automation

本项目遵循 [MIT License](LICENSE) 开源协议。
