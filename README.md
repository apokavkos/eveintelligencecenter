# Eve Intelligence Center (EIC)

A SeAT 5.x plugin for advanced industrial logistics and stockpile management in EVE Online.

## Overview
Eve Intelligence Center (EIC) is an industrial logistics engine designed to optimize continuous-throughput manufacturing pipelines. It implements a "Stockpile Churn" philosophy, focusing on maintaining inventory thresholds across intermediate and final products.

## Core Features
- **Industry Calculator:** Calculate effective inventory considering current assets and in-flight jobs.
- **Stockpile Logistics:** "Green vs. Red" status based on target thresholds.
- **Cascading Deficits:** Automatically propagate deficits from high-tier products to their components.
- **Market Integration:** Fetch prices from SeAT Market Price Cache or ESI.
- **Blueprint Analysis:** Automatic blueprint fetching and material calculation.

## Installation
Add the repository to your SeAT `composer.json`:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/apokavkos/eveintelligencecenter"
        }
    ],
    "require": {
        "apokavkos/eveintelligencecenter": "dev-main"
    }
}
```

Then run `composer update`.

## Configuration
See `INFRASTRUCTURE.md` for environment and infrastructure details.

## Documentation
Additional AI context and project documentation can be found in the [mohrg](https://github.com/apokavkos/mohrg) repository under the `eic/` folder.
