<img src="package/contents/icons/io.github.vmkspv.kopypast.svg" width="128" align="left"/>

# Kopypast

_Kopypast_ is a KDE Plasma applet for quick interaction with text snippets.

<img src="preview.png" width="748" title="Popup widget">

## Installation

<a href="https://store.kde.org/p/2258147">
  <img src="https://kde.org/stuff/clipart/logo/kde-logo-grey-w-slug-vectorized.svg" width="64" align="left"/>
</a>

The recommended installation method is via the [KDE Store](https://store.kde.org/p/2258147).  
Plasmoid can be easily added from Plasma Widget Explorer or Discover (KDE Software Center).

The package for manual installation is available in the [releases](https://github.com/vmkspv/kopypast/releases) section.

## Building from source

The recommended method is to use KPackage Manager:

1. Install the package that provides the `kpackagetool6` command in your distribution.
2. Clone `https://github.com/vmkspv/kopypast.git` repository and `cd kopypast`.
3. Run `kpackagetool6 -t Plasma/Applet --install package` command.

After installation, the applet should be available to add to your Plasma panels/desktop via the widget browser.

To update an existing installation, use `--upgrade` instead of `--install`.

## Contributing

Contributions are welcome!

If you have an idea, bug report or something else, don’t hesitate to [open an issue](https://github.com/vmkspv/kopypast/issues).

> This project follows the [KDE Community Code of Conduct](https://kde.org/code-of-conduct).

## License

Kopypast is released under the [GPL-3.0 license](COPYING).
