using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Components
{
    public enum PanelType
    {
        Attempts,
        Athletes
    }

    public class AggregationPanelInput
    {
        public Athlete AthleteItem;
        public Attempt AttemptItem;

        public AggregationPanelInput()
        {
            AthleteItem = new Athlete();
            AttemptItem = new Attempt();
        }

        public AggregationPanelInput(Athlete athleteItem, Attempt attemptItem)
        {
            AthleteItem = athleteItem;
            AttemptItem = attemptItem;
        }

        public string WeightCategory { get; set; }

        public int Weight { get; set; }

        public bool IsMale { get; set; } = true;

        public bool IsFemale { get; set; } = true;

        public bool IsDisqualified { get; set; }
    }

    public partial class AggregationPanel
    {
        [Parameter]
        public EventCallback<AggregationPanelInput> OnSearchClick { get; set; }

        [Parameter]
        public PanelType PanelType { get; set; }

        public AggregationPanelInput Input { get; set; }

        public string[] WeightCategories { get; set; } = new string[] { "one", "two", "three" };

        protected override void OnInitialized()
        {
            Input = new AggregationPanelInput();
        }

        private void ClearPanel()
        {
            Input = new AggregationPanelInput();
        }
    }
}
