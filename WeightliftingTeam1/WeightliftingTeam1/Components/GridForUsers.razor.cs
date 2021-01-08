using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Components
{
    public partial class GridForUsers<TItem>
    {
        [Parameter]
        public IEnumerable<TItem> GridData { get; set; }

        int CurrentPage { get; set; } = 1;

        int PageSize { get; set; } = 13;

        protected override void OnParametersSet()
        {
            CurrentPage = 1;
            base.OnParametersSet();
        }
    }
}
