{
  "tStrList" Testing -  Copyright (c) Danijel Tkalcec
}
unit TestmemStrList;

interface

{$INCLUDE rtcDefs.inc}

uses
  SysUtils,

  rtcTestCase,
  memStrList;

const
  itemMin='';
  infoNil='';

type
  TTestClass = tStrList;

  TestStrList = {$I mem\class.inc};

implementation

procedure TestStrList.SetReturnValue(a: cardinal);
  begin
  ReturnValue:=AnsiString(IntToStr(a));
  end;

// MyType = 1 (down), 2 (up), 3 (random)
function TestStrList.GetItemValue(a:cardinal):itemType;
  begin
  case MyType of
    1:Result:=AnsiString(IntToStr(a)); // top-down
    2:Result:=AnsiString(IntToStr(MySize-a+1)); // bottom-up
    else
      begin // random
      repeat
        Result := AnsiString(IntToStr(Random(1234567890)));
        until FMyList.search(Result)=infoNil;
      end;
    end;
  end;

constructor TestStrList.{$I mem\create.inc};

destructor TestStrList.{$I mem\destroy.inc};

procedure TestStrList.{$I mem\run.inc};

procedure TestStrList.{$I mem\insert_all.inc};

procedure TestStrList.{$I mem\check_empty.inc};

procedure TestStrList.{$I mem\search_all.inc};

procedure TestStrList.{$I mem\search_down.inc};

procedure TestStrList.{$I mem\search_up.inc};

procedure TestStrList.{$I mem\remove_all.inc};

procedure TestStrList.{$I mem\remove_all_down.inc};

procedure TestStrList.{$I mem\remove_search_up.inc};

procedure TestStrList.{$I mem\remove_search_down.inc};

procedure TestStrList.{$I mem\remove_all_up.inc};

end.
