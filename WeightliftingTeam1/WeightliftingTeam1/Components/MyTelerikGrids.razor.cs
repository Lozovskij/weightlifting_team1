using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Telerik.Blazor.Components;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Components
{
    public partial class MyTelerikGrids
    {
        [Parameter]
        public PanelType PanelType { get; set; }

        [Parameter]
        public DataForGrids DataForGrids { get; set; }

        protected override void OnParametersSet()
        {
            
            base.OnParametersSet();
        }
    }
}
