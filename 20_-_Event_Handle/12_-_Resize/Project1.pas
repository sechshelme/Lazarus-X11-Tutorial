//image image.png
(*
Erstes Fenster mit <b>X11</b> wird erstellt.
Es wird nur ein einziges Eregniss gebraucht.
Ein Tastatur-Event, welches <b>[ESC]</b> abfängt und das Programm beendet.
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

var
  dis: PDisplay;
  win, Subwin1, Subwin2: TWindow;
  Event, ev: TXEvent;
  scr: cint;
  gc: TGC;
  i: integer;
  size_hints: TXSizeHints;
  Region: TRegion;
  r: TXRectangle;

const
    EventMask = KeyPressMask or ExposureMask or PointerMotionMask or ButtonPressMask or ResizeRedirectMask or StructureNotifyMask or SubstructureNotifyMask;
//  EventMask = KeyPressMask or ExposureMask or PointerMotionMask or ButtonPressMask or ResizeRedirectMask;
//  EventMask = KeyPressMask or ExposureMask or PointerMotionMask or ButtonPressMask;

begin
  // Erstellt die Verbindung zum Server
  dis := XOpenDisplay(nil);
  if dis = nil then begin
    WriteLn('Kann nicht das Display öffnen');
    Halt(1);
  end;
  scr := DefaultScreen(dis);
  gc := DefaultGC(dis, scr);



  // Erstellt das Fenster
  win := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 640, 480, 1, $FF, $88);
  Subwin1 := XCreateSimpleWindow(dis, win, 100, 100, 320, 240, 10, $FF00, $8800);
  Subwin2 := XCreateSimpleWindow(dis, win, 250, 100, 320, 240, 0, $FF0000,$880000);
//  win := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 640, 480, 1, BlackPixel(dis, scr), WhitePixel(dis, scr));
//  Subwin1 := XCreateSimpleWindow(dis, win, 100, 100, 320, 240, 10, BlackPixel(dis, scr), WhitePixel(dis, scr));
//7/  Subwin2 := XCreateSimpleWindow(dis, win, 250, 100, 320, 240, 0, BlackPixel(dis, scr), WhitePixel(dis, scr));
  XSetWindowBorderWidth(dis, Subwin2, 15);

  //with  size_hints do begin
  //  flags := PSize or PMinSize or PMaxSize;
  //      flags:=0;
  //  min_width := 640;
  //  max_width := 1640;
  //  min_height := 480;
  //  max_height := 1480;
  //  x := 300;
  //  y := 200;
  //  width:=1000;
  //  height:=1000;
  //end;
  //XSetStandardProperties(dis, win, 'none', 'none', None, nil, 0, @size_hints);

//  XConfigureWindow
// TwindowcXWindowChanges;


  XSelectInput(dis, win, EventMask);
  XSelectInput(dis, Subwin1, EventMask);
  XSelectInput(dis, Subwin2, EventMask);

  // Fenster anzeigen
  XMapWindow(dis, win);
  XMapWindow(dis, Subwin1);
  XMapWindow(dis, Subwin2);

  // Region erzeugen
  Region := XCreateRegion;
  r.x := 10;
  r.y := 10;
  r.Width :=  1000;
  r.Height := 1000;
  XUnionRectWithRegion(@r, Region, Region);
  XSetRegion(dis, gc, Region);



  // Ereignisschleife
  while (True) do begin
    XNextEvent(dis, @Event);

    case Event._type of
      Expose: begin
//        XClearWindow(dis, win);
  //      XClearWindow(dis, Subwin1);
        for i := 0 to 10 do begin
          XSetForeground(dis, gc, $FF);
          XDrawArc(dis, win, gc, random(800) - 200, random(800) - 200, 150, 150, 0, 360 * 64);

          XSetForeground(dis, gc, $FF shl 8);
          XDrawArc(dis, Subwin1, gc, random(500) - 200, random(500) - 200, 150, 150, 0, 360 * 64);

          XSetForeground(dis, gc, $FF shl 16);
          XDrawArc(dis, Subwin2, gc, random(500) - 200, random(500) - 200, 150, 150, 0, 360 * 64);
        end;
      end;
      MotionNotify: begin
        //if Event.xbutton.window = win then begin
        //  WriteLn('root');
        //end;
        //if Event.xbutton.window = Subwin1 then begin
        //  WriteLn('Sub1');
        //end;
        //if Event.xbutton.window = Subwin2 then begin
        //  WriteLn('Sub2');
        //end;
      end;
      ButtonPress: begin
        Write('press');
        XRaiseWindow(dis, Event.xbutton.window);
      end;
      ConfigureNotify: begin
        with Event.xconfigure do begin
          WriteLn('ConfigureNotify ', window, ' ', x, ' ', y, ' ', Width, ' ', Height);
        end;
        if Event.xbutton.window = win then begin
          with Event.xconfigure do begin
            WriteLn('mone');
            //            XMoveWindow(dis, Subwin1, x, y);
            XMoveResizeWindow(dis, Subwin1, x, y, Width, Height);
          end;
        end;
        if Event.xbutton.window = Subwin2 then begin
          WriteLn(Event.xconfigure.x);
          WriteLn(Event.xconfigure.y);
          WriteLn(Event.xconfigure.Width);
          WriteLn(Event.xconfigure.Height);
          WriteLn();
        end;

      end;
      ResizeRequest: begin
        with Event.xresizerequest do begin
          WriteLn('ResizeRequest ', window, ' ', Width, ' ', Height);
          if Event.xbutton.window = win then XMoveResizeWindow(dis, Subwin1, 50, 50, Width - 100, Height - 100);
        end;
      end;
      KeyPress: begin
        // Beendet das Programm bei [ESC]
        if XLookupKeysym(@Event.xkey, 0) = XK_Escape then begin
          Break;
        end;
      end;
    end;

  end;

  // Schliesst Verbindung zum Server
  XCloseDisplay(dis);
end.
//code-
