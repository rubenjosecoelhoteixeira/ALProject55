page 50005 "Customer Category List_PKT"
{
    PageType = List;
    SourceTable = "Customer Category_PKT";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = CustomerCategoryCard_PKT;
    Caption = 'Customer Category List';
    AdditionalSearchTerms = 'ranking, categorization';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Default; Default)
                {
                    ApplicationArea = All;
                }
                field(TotalCustomersForCategory; TotalCustomersForCategory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Customers for Category';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Default Category")
            {
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                ToolTip = 'Create default category';
                Caption = 'Create default category';

                trigger OnAction();
                var
                    CustManagement: Codeunit "Customer Category Mgt_PKT";
                begin
                    CustManagement.CreateDefaultCategory();
                end;
            }
        }
    }
}