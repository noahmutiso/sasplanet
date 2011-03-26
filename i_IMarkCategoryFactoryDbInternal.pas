unit i_IMarkCategoryFactoryDbInternal;

interface

uses
  i_IMarkCategory;

type
  IMarkCategoryFactoryDbInternal = interface
    ['{BBD530DC-6701-4FF3-9C46-413777628134}']
    function CreateCategory(
      AId: Integer;
      AName: string;
      AVisible: Boolean;
      AAfterScale: integer;
      ABeforeScale: integer
    ): IMarkCategory;
  end;

implementation

end.
