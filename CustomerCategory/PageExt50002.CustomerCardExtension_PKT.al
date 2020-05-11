pageextension 50002 "CustomerCardExtension_PKT" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Customer Category Code_PKT"; "Customer Category Code_PKT")
            {
                ToolTip = 'Customer Category';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("Assign default category")
            {
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Caption = 'Assign Default Category';
                ToolTip = 'Assigns Default Category to the current Customer';

                trigger OnAction();
                var
                    CustomerCategoryMgt: Codeunit "Customer Category Mgt_PKT";
                begin
                    CustomerCategoryMgt.AssignDefaultCategory(Rec."No.");
                end;
            }
        }
    }
}