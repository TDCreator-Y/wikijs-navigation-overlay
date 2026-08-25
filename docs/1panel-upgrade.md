# 1Panel 部署与升级

## 首次部署

1. 在阿里云容器镜像服务 ACR 创建一个镜像仓库。
2. 将 GitHub Actions 构建的固定版本镜像推送到该仓库。
3. 在 1Panel 中使用 ACR 镜像地址替换官方 Wiki.js 镜像地址。
4. 保留原有 Wiki.js 数据目录、配置文件和数据库连接。
5. 先在测试实例启动，确认导航和登录后再切换生产实例。

镜像地址格式：

```text
registry.cn-<region>.aliyuncs.com/<namespace>/wikijs-nav-theme:wikijs-v2.5.314-nav-v0.1.0
```

镜像由 GitHub Actions 根据固定的 Wiki.js 上游提交构建，但只推送到 ACR；本项目不会登录或推送 GHCR。

## 升级

1. 备份 Wiki.js 数据库和 1Panel 挂载目录。
2. 创建新的 GitHub Release，例如 `v0.1.1`。
3. 等待 GitHub Actions 构建并推送 ACR 镜像。
4. 在 1Panel 中只修改镜像标签，不修改数据卷和数据库配置。
5. 重启应用并验证菜单、页面、登录和编辑功能。

生产环境不要使用 `latest`。建议使用完整的 Wiki.js 基础版本和主题版本标签。

## 回滚

如果只是主题代码回滚，可以切换回上一版主题镜像。若同时升级了 Wiki.js 基础版本，必须遵循 Wiki.js 官方升级说明，并确认数据库迁移没有超出回滚版本支持范围。
