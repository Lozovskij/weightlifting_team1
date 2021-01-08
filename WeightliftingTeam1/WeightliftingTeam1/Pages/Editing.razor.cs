using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Telerik.Blazor.Components;
using WeightliftingTeam1.Models;

namespace WeightliftingTeam1.Pages
{
    public partial class Editing
    {
        public IEnumerable<Athletes> Athletes { get; set; }
        public IEnumerable<Attempts> Attempts { get; set; }
        public IEnumerable<Competitions> Competitions { get; set; }
        public IEnumerable<CompetitionTypes> CompetitionTypes { get; set; }
        public IEnumerable<Countries> Countries { get; set; }
        public IEnumerable<Disqualifications> Disqualifications { get; set; }
        public IEnumerable<Periods> Periods { get; set; }
        public IEnumerable<Places> Places { get; set; }
        public IEnumerable<Records> Records { get; set; }
        public IEnumerable<RecordTypes> RecordTypes { get; set; }
        public IEnumerable<WeightCategories> WeightCategories { get; set; }

        protected override async Task OnInitializedAsync()
        {
            await Task.Run(() => Athletes = dataRetrievalService.GetData<Athletes>());
            await Task.Run(() => Attempts = dataRetrievalService.GetData<Attempts>());
            await Task.Run(() => Competitions = dataRetrievalService.GetData<Competitions>());
            await Task.Run(() => Countries = dataRetrievalService.GetData<Countries>());
            await Task.Run(() => Disqualifications = dataRetrievalService.GetData<Disqualifications>());
            await Task.Run(() => Periods = dataRetrievalService.GetData<Periods>());
            await Task.Run(() => Places = dataRetrievalService.GetData<Places>());
            await Task.Run(() => Records = dataRetrievalService.GetData<Records>());
            await Task.Run(() => RecordTypes = dataRetrievalService.GetData<RecordTypes>());
            await Task.Run(() => WeightCategories = dataRetrievalService.GetData<WeightCategories>());
        }
    }
}
