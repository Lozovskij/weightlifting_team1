using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Components
{
    public partial class MyTelerikGrid
    {
        [Parameter]
        public PanelType PanelType { get; set; }

        [Parameter]
        public List<IGridModel> DataForGrid { get; set; }
    }
}
