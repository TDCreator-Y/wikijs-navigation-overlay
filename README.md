# Wiki.js Navigation Theme

A maintainable navigation overlay for Wiki.js 2.5.x.

This project keeps Wiki.js as the upstream application and adds:

- expandable navigation with up to three levels;
- independent expand/collapse controls and page links;
- administrator-managed ordering in **Administration → Navigation**;
- indent / outdent controls for changing hierarchy;
- recursive permission filtering;
- a versioned Docker build for 1Panel deployments.

The current target is Wiki.js `v2.5.314` at commit `6f042e97cc2d3acda6b6ff611de8e0faacce91c1`. The only published image registry is Alibaba Cloud Container Registry (ACR).

## Repository model

This repository contains the overlay and patch files, not a permanent fork of the complete Wiki.js source tree. The build downloads the pinned upstream tag, applies the patch, and builds a versioned image.

## Navigation model

Existing flat Wiki.js navigation remains compatible. A header groups following links until the next header or divider. New hierarchy fields (`parentId` and `order`) allow explicit nesting up to three levels from the administration screen.

In Wiki.js administration:

1. Select **Custom Navigation** or **Static Navigation**.
2. Drag items to change their order.
3. Select an item and use **Indent** / **Outdent** to change its level.
4. Click **Apply**.

## Build

The build requires Node.js, Yarn, Git and Docker. The upstream source is fetched at build time.

```powershell
./scripts/prepare-upstream.ps1 -WikiVersion v2.5.314
docker build -f .build/wikijs/dev/build/Dockerfile -t wikijs-nav:2.5.314-nav.0.1.0 .build/wikijs
```

Do not use `latest` in production. Deploy a fixed tag or digest from ACR.

## ACR release

The GitHub Actions workflow publishes only to ACR. Configure these repository secrets:

- `ACR_REGISTRY` - for example `registry.cn-hangzhou.aliyuncs.com`
- `ACR_USERNAME`
- `ACR_PASSWORD`
- `ACR_IMAGE` - for example `my-namespace/wikijs-nav-theme`

The source repository can be public while the ACR repository remains private.

## License

The overlay modifies Wiki.js components and is distributed under AGPL-3.0. Wiki.js source and notices remain attributable to the upstream project.
