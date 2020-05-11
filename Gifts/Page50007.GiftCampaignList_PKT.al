page 50007 "Gift Campaign List_PKT"
{
    PageType = List;
    SourceTable = "GIFT Campaign_PKT";
    UsageCategory = Lists;
    Caption = 'Gift Campaigns';
    ApplicationArea = All;
    AdditionalSearchTerms = 'promotions, marketing';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(CustomerCategoryCode; CustomerCategoryCode)
                {
                    ApplicationArea = All;
                }
                field(ItemNo; ItemNo)
                {
                    ApplicationArea = All;
                }
                field(StartingDate; StartingDate)
                {
                    ApplicationArea = All;
                }
                field(EndingDate; EndingDate)
                {
                    ApplicationArea = All;
                }
                field(MinimumOrderQuantity; MinimumOrderQuantity)
                {
                    ApplicationArea = All;
                }
                field(GiftQuantity; GiftQuantity)
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field(Inactive; Inactive)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    views
    {
        view(ActiveCampaigns)
        {
            Caption = 'Active Gift Campaigns';
            Filters = where(Inactive = const(false));
        }
        view(InactiveCampaigns)
        {
            Caption = 'Inactive Gift Campaigns';
            Filters = where(Inactive = const(true));
        }
    }
}