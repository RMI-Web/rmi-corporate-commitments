<script context="module">
	const mores = new Set();
</script>

<script>
	import { onMount } from "svelte";

	export let text;
	export let hiddenLabel = "Click or tap to learn more about this statistic";
	export let visible = false;
	export let id;
	export let flip = false;
	export let fullwidth = false;

	let moreElement;
	const tooltipWidth = 250;

	function handleClick(e) {
		if (visible) {
			hide();
		} else {
			hideOthers();
			show();
		}
	}

	// Hide all the tooltips except the one we want to see
	function hideOthers() {
		mores.forEach(m => {
			if (moreElement !== m) m.hide();
		});
	}
	export function hide() {
		visible = false;
	}
	function show() {
		visible = true;
	}

	onMount(() => {
		mores.add({ hide });
	});
</script>

<style>
	.more {
		--color-background: var(--color-gray);
		display: inline-flex;
		align-items: center;
		justify-content: center;
		color: white;
		padding: 0;
		font: bold var(--font-size-very-small) / 1.3em var(--sans-serif-fonts);
		height: 1.1rem;
		width: 1.1rem;
		min-height: var(--tap-target, 1rem);
		min-width: var(--tap-target, 1rem);
		background-color: transparent;
		border: none;
		border-radius: 50%;

		cursor: pointer;
		position: relative;
		transition: background var(--speed-transition-fast) ease-in-out;
	}

	.more:hover,
	.more:focus {
		--color-background: var(--color-gray-dark);
	}

	.more.fullwidth {
		position: unset;
	}

	.more__icon {
		font-family: var(--serif-fonts);
		font-style: italic;

		display: flex;
		align-items: center;
		justify-content: center;
		width: 1rem;
		height: 1rem;
		border-radius: 50%;

		background: var(--color-background);
		color: white;

		transition: background var(--speed-transition-fast) ease-in-out;
	}

	.more__text {
		padding: calc(var(--gap) / 2) 1rem calc(var(--gap) / 2) calc(var(--gap) / 2);
		background: var(--color-background);

		position: absolute;
		z-index: 2;
		left: 0;

		width: var(--tooltip-width);
		margin: 0;
		opacity: 0;
		transition: opacity var(--speed-transition-fast) ease-in-out;
		text-align: left;
	}

	.fullwidth .more__text {
		top: unset;
		left: 0;
		transform: translate(0, 3.5rem);
	}

	.more__text__close {
		position: absolute;
		top: 0;
		right: 0;
		height: 1rem;
		width: 1rem;
		border: none;
		padding: 0;
		cursor: pointer;
		color: white;
		background-color: transparent;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.more__text__close::after {
		font-weight: bold;
		font-size: 16px;
		content: "\00D7";
	}
	/* VISIBLE STATE */

	.visible {
		--color-background: black;
	}
	.visible .more__text {
		opacity: 1;
	}

	@media all and (min-width: 1024px) {
		.more__text {
			top: calc(0.5 * var(--gap));
			transform: none;
			left: calc(100% + 0.5 * var(--gap));
		}
		.flip .more__text {
			left: unset;
			right: calc(100% + 0.5 * var(--gap));
		}
	}
</style>

<button
	id="more-{id}"
	class="more"
	class:flip
	class:fullwidth
	class:visible
	style:--tooltip-width="{tooltipWidth}px"
	bind:this={moreElement}
	aria-labelledby="more-label-{id}"
	on:click={handleClick}>
	<span class="more__icon">i</span>
	<span id="more-label-{id}" class="visually-hidden">
		{hiddenLabel}
	</span>
	{#if visible}
		<p class="more__text">
			<button class="more__text__close" on:click|stopPropagation={hide}>
				<span class="visually-hidden">Close this info box.</span>
			</button>
			{@html text}
		</p>
	{/if}
</button>
