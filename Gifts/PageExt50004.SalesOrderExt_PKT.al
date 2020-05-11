pageextension 50004 SalesOrderExt_PKT extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            action(AddFreeGifts)
            {
                Caption = 'Add Free Gifts';
                ToolTip = 'Add Free Gifts to the current Sales Order based on Active Campaigns';
                ApplicationArea = All;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GiftManagement.AddGifts(Rec);
                end;
            }
        }
    }
    var
        Giftmanagement: Codeunit GiftManagement_PKT;
}