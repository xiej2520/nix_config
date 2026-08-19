# Frontend smoke test checklist

Run these checks against the deployed Dufs page after changing `index.html`, `index.js`, or `index.css`.

## Layout

- [ ] Desktop list view aligns icon, name, modified date, size, and actions.
- [ ] Desktop list rows alternate colors and use the available width.
- [ ] Desktop and mobile tile views keep names centered within each tile.
- [ ] Mobile header spans the viewport; home, search, and toolbar controls remain usable.
- [ ] Long names do not push row actions off-screen.
- [ ] Details list mode preserves table alignment and provides horizontal scrolling when needed.
- [ ] Sorting preserves the details preference.
- [ ] The Tiles/List control works with touch input.

## Uploads and actions

- [ ] Individual file picker uploads a file.
- [ ] Folder picker uploads nested files and creates parent directories first.
- [ ] Dragging a folder uploads nested files and creates parent directories first.
- [ ] Upload progress, failure, and retry states work.
- [ ] New folder, new file, rename, delete, download, and edit still work.
- [ ] Search, login, logout, and authenticated downloads still work.

## Deployment

- [ ] Dufs substitutes `__INDEX_DATA__` and `__ASSETS_PREFIX__` in the deployed page.
- [ ] Browser DevTools shows the deployed `index.js` contains `MKCOL` and `webkitRelativePath`.
- [ ] A hard refresh loads the updated assets rather than a cached bundle.
