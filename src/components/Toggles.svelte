<script>
	import ButtonToggles from "./ButtonToggles.svelte";

	import Toggle from "./Toggle.svelte";

	// UTILS
	import { multipliers } from "../stores.js";
	import { marked } from "marked";

	// COMPONENTS
	import Button from "./Button.svelte";
	import PickerPresets from "./PickerPresets.svelte";
	import ChartOverall from "./ChartOverall.svelte";
	import { fireEvent } from "../utils/analytics";

	export let togglesLabel;
	export let togglesDescription = "";
	export let dataLabel = "";
	export let toggles = [];
	export let defaultMultipliers = {};

	export let overallMicrocopy = {};

	// FOR THE PRESETS
	export let presets = {};
	export let presetsMicrocopy = {};

	let visible = false;

	const doc = document ? document.body : null;
	function openControls(e) {
		if (visible) {
			if (doc) doc.classList.remove("scroll-lock");
			visible = false;
		} else {
			if (doc) doc.classList.add("scroll-lock");
			visible = true;
		}
	}

	function onReset(e) {
		$multipliers = defaultMultipliers;
		fireEvent("Toggles reset");
	}
</script>

<style>
	.toggles {
		background: inherit;
		height: 100%;
		width: 100%;
		position: fixed;
		top: 0;
		z-index: 1000;
		transition: right var(--speed-transition) ease-in-out;
		right: 100%;

		overflow: scroll;
	}

	.toggles.visible {
		right: 0;
	}

	.toggles__form {
		padding: 1rem;
	}

	@media all and (min-width: 1024px) {
		.toggles {
			--button-height: 3rem;
			position: relative;
			right: unset;
			height: 100%;
			padding-bottom: var(--gap);
		}

		.toggles__form {
			padding: 0;
			overflow: visible;
		}

		.toggles__ui {
			flex: 1 1;
			max-height: calc(100% - var(--button-height));
		}

		.toggles__buttons {
			flex: 0 0 var(--button-height);
			display: flex;
			gap: var(--gap);
		}
	}
</style>

<ButtonToggles {visible} on:click={openControls} />
<div class="toggles stack" class:visible>
	<ChartOverall {...overallMicrocopy} />
	<div class="toggles__form stack">
		<PickerPresets {presets} {...presetsMicrocopy} column={true} />
		<h2 class="header">{dataLabel}</h2>
		{#each toggles.filter(t => t.id === "use_estimated") as t}
			<Toggle {...t} />
		{/each}
		<h2 class="header">{togglesLabel}</h2>
		{#if togglesDescription}{@html marked.parse(togglesDescription)}{/if}
		<div class="toggles__ui stack--margin">
			{#each toggles.filter(t => t.id !== "use_estimated") as t}
				<Toggle {...t} />
			{/each}
		</div>
		<div class="toggles__buttons">
			<Button on:click={onReset}>Reset</Button>
		</div>
	</div>
</div>
