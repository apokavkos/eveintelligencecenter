import streamlit as st
import pandas as pd
import math

st.set_page_config(page_title="EVE Import Planner", layout="wide")

URLS = {
    "Understocked": "https://goonmetrics.apps.goonswarm.org/importing/1049588174021/stock/",
    "High Margin": "https://goonmetrics.apps.goonswarm.org/importing/1049588174021/markup/",
    "Items to Seed": "https://goonmetrics.apps.goonswarm.org/importing/1049588174021/seed/"
}

@st.cache_data(ttl=600)
def fetch_data(url):
    try:
        # read_html returns a list of dataframes
        dfs = pd.read_html(url)
        if dfs:
            df = dfs[0]
            # Add the 'Import?' boolean column set to False by default
            df.insert(0, "Import?", False)
            if "Wk Volume" in df.columns:
                # Convert 'Wk Volume' to numeric, removing commas if present
                df["Wk Volume"] = pd.to_numeric(df["Wk Volume"].astype(str).str.replace(',', ''), errors='coerce').fillna(0)
            return df
        return pd.DataFrame()
    except Exception as e:
        st.error(f"Failed to fetch data from {url}: {e}")
        return pd.DataFrame()

st.title("EVE Import Planner")
st.markdown("Select items to import, configure your volume targets, and copy your Jita Multibuy lists below.")

tabs = st.tabs(list(URLS.keys()))

for tab, (tab_name, url) in zip(tabs, URLS.items()):
    with tab:
        st.subheader(tab_name)
        
        df = fetch_data(url)
        if df.empty:
            st.warning("No data found or failed to load.")
            continue
            
        # Select target percentage
        pct_options = {"5%": 0.05, "10%": 0.10, "25%": 0.25, "50%": 0.50}
        selected_pct = st.selectbox("Target Percentage of Weekly Volume", list(pct_options.keys()), key=f"pct_{tab_name}")
        multiplier = pct_options[selected_pct]
        
        # Display data editor
        edited_df = st.data_editor(
            df,
            hide_index=True,
            column_config={
                "Import?": st.column_config.CheckboxColumn("Import?", help="Select items to generate multibuy string")
            },
            key=f"editor_{tab_name}",
            use_container_width=True
        )
        
        # Filter selected rows
        selected_rows = edited_df[edited_df["Import?"] == True]
        
        if not selected_rows.empty:
            st.divider()
            st.subheader("Jita Multibuy Output")
            
            output_lines = []
            for _, row in selected_rows.iterrows():
                # Check for item name. The table usually has 'Item' or 'Name'.
                item_col = "Item" if "Item" in row else "Type" if "Type" in row else None
                if not item_col:
                    # Fallback to the second column if we can't guess the name
                    item_col = df.columns[1] 
                
                item_name = str(row[item_col])
                volume = float(row.get("Wk Volume", 0))
                
                # Calculate quantity and round up
                qty = math.ceil(volume * multiplier)
                if qty > 0:
                    output_lines.append(f"{item_name} {qty}")
            
            if output_lines:
                multibuy_text = "\n".join(output_lines)
                st.code(multibuy_text, language="text")
            else:
                st.info("Selected items have 0 volume.")
