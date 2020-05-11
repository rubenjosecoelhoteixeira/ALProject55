pageextension 50005 VendorCardExt_PKT extends "Vendor Card"
{
    actions
    {
        addafter("Co&mments")
        {
            action(QualityClassification)
            {
                Caption = 'Quality Classification';
                ApplicationArea = All;
                Image = QualificationOverview;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Vendor Quality Card_PKT";
                RunPageLink = "Vendor No." = field("No.");
            }
        }
    }
}