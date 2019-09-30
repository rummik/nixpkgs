{ stdenv, autoPatchelfHook
, atk
, bzip2
, cairo
, cups
, gdk_pixbuf
, gnome2
, gtk3-x11
, jasper
, libGL
, libglvnd
, libsForQt59
, lzma
, nspr
, nss
, python27Packages
, qt59
, readline
, udev
, xlibs
, zlib
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "hiri";
  version = "1.6.3";

  src = fetchTarball {
    url = https://feedback.hiri.com/downloads/Hiri.tar.gz;
    sha256 = "1vs0cz4jccn8kya89z7gc961dghl53mkz0gmv8vwwn293v8qqwsr";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs =
    [
      atk
      bzip2
      cairo
      cups
      gdk_pixbuf
      gtk3-x11
      jasper
      libglvnd
      lzma
      nspr
      nss
      readline
      stdenv.cc.cc
      zlib
    ]

    ++

    (with gnome2; [
      pango
    ])

    ++

    (with python27Packages; [
      cdecimal
    ])

    ++

    (with qt59; [
      qt3d
      qtconnectivity
      qtgamepad
      qtlocation
      qtsensors
      qtwebsockets
    ])

    ++

    (with libsForQt59; [
      libqglviewer
    ])

    ++

    (with xlibs; [
      libXScrnSaver
      libXcursor
      libXdamage
      libXrandr
      libXtst
    ]);

  runtimeDependencies = [
    #bzip2
    #jasper
    libglvnd
    libGL
  ];

  installPhase = /* sh */ ''
    mkdir -p $out/{opt/hiri,bin,lib}
    cp -ar . $out/opt/hiri
    ln -s $out/opt/hiri/hirimain $out/bin/hiri
    ln -s ${bzip2.out}/lib/libbz2.so.1 $out/lib/libbz2.so.1.0
    ln -s ${jasper.out}/lib/libjasper.so $out/lib/libjasper.so.1
    ln -s ${python27Packages.cdecimal.out}/lib/python2.7/site-packages/cdecimal.so $out/lib/libmpdec.so.2
  '';

  postFixup = /* sh */ ''
    #substituteInPlace $out/share/applications/mailspring.desktop \
      #--replace /usr/bin $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    license = licenses.unfree;
    maintainers = with maintainers; [ rummik ];
    homepage = https://getmailspring.com;
    platforms = [ "x86_64-linux" ];
  };
}
