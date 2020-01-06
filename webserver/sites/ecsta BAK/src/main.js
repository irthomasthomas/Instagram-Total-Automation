import App from './App.svelte';
// TODO: ARE WE WASTING TIME ROUTING TO DOMAIN?
const app = new App({
	target: document.body,
	props: {
		name: 'world'
	}
});

export default app;
