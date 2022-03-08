//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EvilNFT is ERC1155, Ownable {
    uint256 public constant GHOSTSCRIPT_CVE_2017_8291  = 0;
    uint256 public constant GHOSTSCRIPT_CVE_2018_16509 = 1;
    uint256 public constant GHOSTSCRIPT_CVE_2019_14811 = 2;
    uint256 public constant GHOSTSCRIPT_CVE_2019_14812 = 3;
    uint256 public constant GHOSTSCRIPT_CVE_2019_6116  = 4;
    uint256 public constant GHOSTSCRIPT_CVE_2019_10216 = 5;
    uint256 public constant GIFOEB_CVE_2017_15277      = 6;
    uint256 public constant XBM_CVE_2018_16323         = 7;
    uint256 public constant GRAPHICSMAGICK_CVE_2019_12921 = 8;
    uint256 public constant IMAGETRAGICK_CVE_2016_3714 = 9;
    uint256 public constant CMDINJ_CVE_2020_29599      = 10;
    uint256 public constant SSRF_FEIMAGE_XLINK_HREF    = 11;
    uint256 public constant SSRF_FOREIGNOBJECT_IFRAME_SRC    = 12;
    uint256 public constant SSRF_FOREIGNOBJECT_IMG_SRC    = 13;
    uint256 public constant SSRF_IMAGE_HREF    = 14;
    uint256 public constant SSRF_IMAGE_XLINK_HREF    = 15;
    uint256 public constant SSRF_LINK_HREF    = 16;
    uint256 public constant SSRF_PATH_FILL    = 17;
    uint256 public constant SSRF_PATTERN_IMAGE_XLINK_HREF    = 18;
    uint256 public constant SSRF_RECT_FILL_SMB    = 19;
    uint256 public constant SSRF_RECT_FILL    = 20;
    uint256 public constant SSRF_STYLE_CDATA_FONT_SRC    = 21;
    uint256 public constant SSRF_STYLE_CDATA_IMPORT_URL    = 22;
    uint256 public constant SSRF_STYLE_IMPORT    = 23;
    uint256 public constant SSRF_TEXTPATH_XLINK_HREF    = 24;
    uint256 public constant SSRF_TREF_XLINK_HREF    = 25;
    uint256 public constant SSRF_USE_XLINK_HREF    = 26;
    uint256 public constant SSRF_XI_INCLUDE    = 27;
    uint256 public constant SSRF_XML_STYLESHEET    = 28;
    uint256 public constant XSS    = 29;
    uint256 public constant XXE_INTERNAL_ENTITIES    = 30;
    uint256 public constant XXE_LOCAL_FILE_READ    = 31;
    uint256 public constant XXE_SSRF    = 32;
    uint256 public constant GHOSTSCRIPT_0DAY_RCE    = 33;
    uint256 public constant GHOSTSCRIPT_CVE_2019_14813    = 34;
    uint256 public constant COLLABORATOR    = 35;

    constructor() ERC1155("https://evil-nft.vercel.app/api/{id}.json") {
        for (uint i = 0; i <= COLLABORATOR; i++) {
          _mint(msg.sender, i, 1, "");
        }
    }
}
