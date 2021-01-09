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
        public Task<IEnumerable<TItem>> SearchDataTask { get; set; }

        public IEnumerable<TItem> DefaultGridData { get; set; }
        public IEnumerable<TItem> GridData { get; set; }

        public bool IsLoaded { get; set; }

        int CurrentPage { get; set; } = 1;

        int PageSize { get; set; } = 13;

        protected override void OnParametersSet()
        {
            CurrentPage = 1;
            base.OnParametersSet();
        }

        protected override async Task OnInitializedAsync()
        {
            GridData = await SearchDataTask;
            DefaultGridData = GridData;
            IsLoaded = true;
        }

        public void SetDefaultData()
        {
            GridData = DefaultGridData;
        }

        
    }
}
