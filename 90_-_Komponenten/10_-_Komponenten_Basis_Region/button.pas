unit Button;

{$mode ObjFPC}{$H+}

interface

uses
  unixtype, ctypes, xlib, xutil, keysym, x,
  Panel, Component;

type

  TX11Button = class(TX11Panel)
  protected
    procedure DoOnPaint; override;
  public
    constructor Create(TheOwner: TX11Component);
    destructor Destroy; override;
  end;

implementation

constructor TX11Button.Create(TheOwner: TX11Component);
begin
  inherited Create(TheOwner);

  IsMouseDown := False;
  IsButtonDown := False;
  Width := 75;
  Height := 25;
  BorderWidth := 3;
end;

destructor TX11Button.Destroy;
begin
  inherited Destroy;
end;

procedure TX11Button.DoOnPaint;
begin
  inherited DoOnPaint;

  if IsButtonDown then begin
    Bevel := bvLowred;
  end else begin
    Bevel := bvRaised;
  end;

  XSetForeground(dis, gc, $00);
  XDrawRectangle(dis, win, gc, Left, Top, Width - 1, Height - 1);
  if IsButtonDown then begin
    XDrawString(dis, win, gc, Left + 8 + BorderWidth, Top + 15 + BorderWidth, PChar(Caption), Length(Caption));
  end else begin
    XDrawString(dis, win, gc, Left + 7 + BorderWidth, Top + 14 + BorderWidth, PChar(Caption), Length(Caption));
  end;
end;

end.
