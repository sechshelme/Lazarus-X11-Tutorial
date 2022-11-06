//image image.png
(*
Kreise und Elipsen zeichnen:

- [XDrawArc](https://tronche.com/gui/x/xlib/graphics/drawing/XDrawArc.html)
- [XFill](https://tronche.com/gui/x/xlib/graphics/filling-areas/XFillArc.html)
*)
//lineal
//code+
program Project1;

uses
  unixtype,
  ctypes,
  xlib,
  xutil,
  keysym,
  x;

type
  TBitMapData = record
    Width, Height: integer;
  end;

  { TMyWin }

  TMyWin = class(TObject)
  private
    dis: PDisplay;
    scr: cint;
    win: TWindow;
    gc: TGC;
    BitmapData: TBitMapData;
    visual: PVisual;
    image: PXImage;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
  end;

  constructor TMyWin.Create;
  var
    image32: array of array of record
      b, g, r, a: byte;
    end;
    x, y: integer;

  begin
    inherited Create;
    with BitmapData do begin
      Width := 256;
      Height := 256;
    end;

    // Erstellt die Verbindung zum Server
    dis := XOpenDisplay(nil);
    if dis = nil then begin
      WriteLn('Kann nicht das Display öffnen');
      Halt(1);
    end;
    scr := DefaultScreen(dis);
    gc := DefaultGC(dis, scr);

    win := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 640, 480, 1, BlackPixel(dis, scr), WhitePixel(dis, scr));
    visual := DefaultVisual(dis, scr);
    if visual^.c_class <> TrueColor then begin
      WriteLn('Kein TrueColor Modus');
      Halt(1);
    end;

    SetLength(image32, BitmapData.Width, BitmapData.Height);
    for y := 0 to BitmapData.Height - 1 do begin
      for x := 0 to BitmapData.Width - 1 do begin
        image32[y, x].r := $00;
        image32[y, x].g := $FF;
        image32[y, x].b := $00;
        image32[y, x].a := $FF;
      end;
    end;
    image := XCreateImage(dis, visual, DefaultDepth(dis, DefaultScreen(dis)), ZPixmap, 0, PChar(image32), BitmapData.Width, BitmapData.Height, 32, 0);
    ;

    XSelectInput(dis, win, KeyPressMask or ExposureMask);
    XMapWindow(dis, win);
  end;

  destructor TMyWin.Destroy;
  begin
    // Schliesst Verbindung zum Server
    XCloseDisplay(dis);
    inherited Destroy;
  end;

  procedure TMyWin.Run;
  var
    Event: TXEvent;
  begin
    // Ereignisschleife
    while (True) do begin
      XNextEvent(dis, @Event);

      case Event._type of
        Expose: begin
          XClearWindow(dis, win);
          XPutImage(dis, win, gc, image, 0, 0, 0, 0, BitmapData.Width, BitmapData.Height);

          //          XReadBitmapFile(dis,win,gc,'image.png', w,h, br);
        end;
        KeyPress: begin
          // Beendet das Programm bei [ESC]
          if XLookupKeysym(@Event.xkey, 0) = XK_Escape then begin
            Break;
          end;
        end;
      end;

    end;
  end;

var
  MyWindows: TMyWin;

begin
  MyWindows := TMyWin.Create;
  MyWindows.Run;
  MyWindows.Free;
end.
//code-