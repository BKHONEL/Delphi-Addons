{
  "Balanced Binary search List"
  - Copyright (c) 2003-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @exclude
}

unit memStrList;

{$INCLUDE rtcDefs.inc}

interface

uses
  SysUtils, memPtrPool;

type
  itemType=AnsiString;
  infoType=AnsiString;

{$I sort\types.inc}

type
  tStrList={$I sort\class.inc};

implementation

const
  itemMin:itemType='';
  infoNil:infoType='';

function tStrList.{$I sort\Empty.inc};

function tStrList.{$I sort\NewNode.inc};

procedure tStrList.{$I sort\PoolSize.inc};

procedure tStrList.{$I sort\DelNode.inc};

constructor tStrList.{$I sort\Create.inc};

procedure tStrList.{$I sort\Change.inc};

procedure tStrList.{$I sort\RemoveThis.inc};

procedure tStrList.{$I sort\RemoveAll.inc};

destructor tStrList.{$I sort\Destroy.inc};

function tStrList.{$I sort\Search.inc};

function tStrList.{$I sort\SearchMin.inc};

function tStrList.{$I sort\SearchMax.inc};

function tStrList.{$I sort\SearchL.inc};

function tStrList.{$I sort\SearchG.inc};

function tStrList.{$I sort\SearchLE.inc};

function tStrList.{$I sort\SearchGE.inc};

procedure tStrList.{$I sort\InsertSplit.inc};

procedure tStrList.{$I sort\Insert.inc};

procedure tStrList.{$I sort\RemoveAddP.inc};

function tStrList.{$I sort\RemoveGetP.inc};

procedure tStrList.{$I sort\Remove.inc};

function tStrList.{$I sort\Count.inc};

end.
