{
  "Pointer Pool"
  - Copyright (c) 2003-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @exclude
}

unit memPtrPool;

{$INCLUDE rtcDefs.inc}

interface

type
  tPtrPoolElems = array of pointer;

  tPtrPool = class(TObject)
    private
      pObjs:tPtrPoolElems;
      fCount,fSize:integer;
      procedure SetSize(x:integer);
    public
      constructor Create(Size:integer=0);
      destructor Destroy; override;
      function Put(x:pointer):boolean; // if Pool is full, return FALSE and Free object memory
      function Get:pointer; // if Pool is empty, return FALSE (you have to create the Object)
      property Size:integer read fSize write SetSize;
      property Count:integer read fCount;
    end;

implementation

{ tPrtPool }

constructor tPtrPool.Create(Size: integer);
  begin
  inherited Create;
  fSize:=Size;
  if fSize>0 then
    SetLength(pObjs,fSize);
  fCount:=0;
  end;

destructor tPtrPool.Destroy;
  begin
  fCount:=0;
  if fSize>0 then
    begin
    SetLength(pObjs,0);
    fSize:=0;
    end;
  inherited;
  end;

function tPtrPool.Get:pointer;
  begin
  if fCount>0 then
    begin
    Dec(fCount);
    Result:=pObjs[fCount];
    end
  else
    Result:=nil;
  end;

function tPtrPool.Put(x: pointer): boolean;
  begin
  if fCount<fSize then
    begin
    pObjs[fCount]:=x;
    Inc(fCount);
    Result:=True;
    end
  else
    Result:=False;
  end;

procedure tPtrPool.SetSize(x: integer);
  begin
  if x<>fSize then
    begin
    fSize:=x;
    SetLength(pObjs,fSize);
    end;
  end;

end.


