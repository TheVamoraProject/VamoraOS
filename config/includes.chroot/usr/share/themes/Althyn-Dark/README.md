# Althyn-Dark window theme

Openbox 3 and labwc decorations built to match the Althyn Settings app —
same zinc palette, same 46px left-aligned title bar, same lucide icon set,
same neutral hover pill on all three window controls (no red close button,
because `WindowControl` in `Settings/src/qml/main.qml` doesn't have one).

This is the dark variant of two variants, mapped from the two sides of the
`darkTheme ? ... : ...` palette in `main.qml`. The other is `Althyn-Light`
(shipped separately since Althyn doesn't have a default — the user picks).

| Token | `Althyn-Dark` | `Althyn-Light` |
|---|---|---|
| `bgPrimary` — titlebar | `#000000` | `#fafafa` |
| `bgSurface` — menus, OSD | `#18181b` | `#ffffff` |
| `bgCard` | `#27272a` | `#f4f4f5` |
| `bgCardHover` — button hover | `#3f3f46` | `#e4e4e7` |
| `borderColor` | `#27272a` | `#e4e4e7` |
| `txtPrimary` — active title | `#f4f4f5` | `#18181b` |
| `txtMuted` — inactive title | `#71717a` | `#a1a1aa` |
| icon stroke (`AppIcon` overlay) | `#e4e4e7` | `#303640` |
| `accentColor` — OSD fill | `#7dd3fc` | `#7dd3fc` |

## What's in the box

```
Althyn-Dark/
├── openbox-3/
│   ├── themerc          Openbox 3 theme
│   ├── *.xbm            active button masks (10px by default)
│   ├── masks/8,10,12,14,16/   the same glyphs at other sizes
│   └── set-button-size.sh     swap the active set
├── labwc/
│   ├── themerc          labwc theme (rounded hover pills, shadows, OSD)
│   └── *-active.svg     lucide button icons, active + inactive
└── preview.png
```

Button glyphs match what the app actually draws, not the lucide
`minimize`/`maximize` corner-bracket icons: minimise is the `−` bar,
maximise is the rounded square, restore is `restore.svg`, close is
`lucide-x` (`close.svg`) verbatim.

## Install

Both Openbox and labwc read theme folders from `~/.themes` (labwc also
accepts `~/.local/share/themes`), so one copy serves both window managers —
there's no separate "labwc install" step, just this:

```sh
mkdir -p ~/.themes
cp -r Althyn-Dark ~/.themes/
```

For Openbox you can instead double-click `Althyn-Dark.obt`, or:

```sh
obconf --install Althyn-Dark.obt
```

## Openbox — pick the theme

```xml
<theme>
  <name>Althyn-Dark</name>
  <titleLayout>LIMC</titleLayout>
  <keepBorder>yes</keepBorder>
  <font place="ActiveWindow">
    <name>Inter</name><size>10</size>
    <weight>bold</weight><slant>normal</slant>
  </font>
  <font place="InactiveWindow">
    <name>Inter</name><size>10</size>
    <weight>normal</weight><slant>normal</slant>
  </font>
  <font place="MenuItem">
    <name>Inter</name><size>10</size>
    <weight>normal</weight><slant>normal</slant>
  </font>
</theme>
```

That block lives in `~/.config/openbox/rc.xml`. `LIMC` puts the label first
and then `−`, `□`, `×` on the right, matching `windowControls` in
`main.qml`. Apply with `openbox --reconfigure` (or `menu > Reconfigure` if
you have the default root menu).

Inter ships with the repo at `Settings/src/qml/assets/fonts/inter/` —
install those TTFs to `~/.local/share/fonts/` and run `fc-cache -f` if the
system doesn't already have Inter.

## labwc — pick the theme

labwc reads its own `rc.xml`, normally at `~/.config/labwc/rc.xml` (create
the file/folder if it doesn't exist yet — labwc runs on defaults without
one). Add or edit the `<theme>` block:

```xml
<labwc_config>
  <theme>
    <name>Althyn-Dark</name>
    <cornerRadius>18</cornerRadius>
    <dropShadows>yes</dropShadows>
    <font place="ActiveWindow">
      <name>Inter</name><size>10</size>
      <weight>bold</weight><slant>normal</slant>
    </font>
    <titlebar>
      <layout>:iconify,max,close</layout>
    </titlebar>
  </theme>
</labwc_config>
```

`<name>` just has to match the folder name under `~/.themes` — that's the
whole "selection" mechanism, there's no separate config file to point at.
`cornerRadius: 18` matches the app's own `background { radius: 18 }`. The
empty left side of `<titlebar><layout>` drops the window icon, matching the
app's chrome (no icon in the Settings titlebar).

Reload without logging out — either:

```sh
labwc --reconfigure
```

or send it a SIGHUP:

```sh
killall -SIGHUP labwc
```

If you start labwc from a session/display manager and don't have a
terminal open in the session, `SIGHUP` via that command from a TTY works
just as well as running `labwc --reconfigure` inside it.

labwc needs no equivalent of Openbox's button-size dance — its buttons are
SVGs, scaled to `window.button.width`, so they stay crisp at any font size.

## If the Openbox buttons look wrong

Openbox sizes titlebar buttons from the **title font**:

```
label_height = title font height
button_size  = label_height - 2
```

and then blits each `.xbm` with the clip origin at the button's top-left
corner. A mask bigger than `button_size` is **clipped**, never scaled or
centred — so an oversized maximise square shows up as a bare top-left
corner `⌐`, and the X shows up as a single arm `↘`.

The active masks here are 10px, which fits a title font of roughly 10pt at
96dpi. If they still look cut off, drop a size:

```sh
cd ~/.themes/Althyn-Dark/openbox-3
./set-button-size.sh 8
openbox --reconfigure
```

If instead they look small and lost in the bar, go the other way
(`12`, `14`, `16`) or raise the title font — a bigger font buys a bigger
button box, and the two need to move together. 16px masks want a title font
around 13-14pt, which is larger than the app's own 13px DemiBold title, so
10-12 is usually the honest match.

## The square next to the title

That's the window icon, which Openbox's default `titleLayout` (`NLIMC`)
puts on the left. The Settings chrome has no icon, so use `LIMC` as in the
rc.xml above to drop it. obconf's own preview pane always draws it
regardless of your setting — don't read too much into the preview.

## Notes / limitations

- Openbox draws square button backgrounds, so the circular hover pill from
  `WindowControl` only appears under labwc
  (`window.active.button.hover.bg.corner-radius: 14`). Openbox gets the
  same `#3f3f46` fill as a rectangle.
- Openbox also has no rounded window corners. labwc does, via
  `cornerRadius` above.
- The titlebar height is font-driven on both WMs. `padding.height: 14` plus
  Inter at 10pt lands around 46px; nudge `padding.height` if your DPI puts
  it off. Note that `padding.height` does not affect button size — only the
  font does.
- labwc ignores theme keys it doesn't recognise and logs a warning. The
  `titlebar.height`, shadow and snapping keys need labwc 0.8+; on older
  versions they're skipped harmlessly.
- The OSD fill uses `#7dd3fc`, the default `accentColor`. If you change the
  accent in Vamify, edit `osd.hilight.bg.color` (Openbox) /
  `osd.window-switcher.preview.border.color` and the `snapping.*` keys
  (labwc) to match.
