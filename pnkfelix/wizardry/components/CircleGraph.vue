<script setup lang="ts">
  import { ref, computed } from 'vue'

const props = defineProps({
  titles: {
    type: Array,
    required: true
  },
})

const radius = 150
const nodeRadius = 30
const svgSize = 500
const centerPoint = svgSize / 2
const arrowSize = 10

const nodes = computed(() => {
  return props.titles.map((title, index) => {
    const angle = (Math.PI * 2 / props.titles.length) * index - Math.PI / 2;
    return {
      id: index + 1,
      title,
      angle,
      x: centerPoint + radius * Math.cos(angle),
      x_list: index + 250,
      y_list: index * 40 + 50,
      y: centerPoint + radius * Math.sin(angle),
    }
  })
})

function getArcPath(startNode, endNode) {
  const startAngle = startNode.angle
  const endAngle = endNode.angle

  // This is questionable math that the AI hallucinated.
  const startX = startNode.x + nodeRadius * Math.cos(startAngle)
  const startY = startNode.y + nodeRadius * Math.sin(startAngle)
  const endX = endNode.x - nodeRadius * Math.cos(endAngle)
  const endY = endNode.y - nodeRadius * Math.sin(endAngle)

  const arrowAngle = Math.atan2(endY - startY, endX - startX)
  const arrowX = endX - arrowSize * Math.cos(arrowAngle)
  const arrowY = endY - arrowSize * Math.sin(arrowAngle)

  const arcRadius = radius * 0.9

  return {
    path: `M ${startX} ${startY} A ${arcRadius} ${arcRadius} 0 0 1 ${arrowX} ${arrowY}`,
    arrowX: endX,
    arrowY: endY,
    angle: arrowAngle,
  }
}

const paths = computed(() => {
  const result = nodes.value.map((node, index) => {
    const nextIndex = (index + 1) % nodes.value.length
    const path = getArcPath(node, nodes.value[nextIndex])
    console.log(`Path ${index}:`, path) // Debugging
    return path
  })
  console.log("All paths:", result) // Debugging
  return result
})
</script>

<template>
  <svg :width=svgSize :height=svgSize class="mx-auto">
    <g>
      <path 
          d="M 10 10 L 20 20" 
          fill="none" 
          stroke="black" 
          stroke-width="2"
	  />
    </g>

    <!-- Connecting paths with arrows -->
    <g>
      <path
	  v-for="(path, index) in paths"
	  :key="`path-${index}`" 
	  :d="path.path"
	  fill="none"
	  stroke="black"
	  stroke-width="2"
	  />
    </g>
    <!-- Arrowheads -->
    <g v-for="(path,index) in paths" :key="`arrow-${index}`">
      <polygon
	  :points="`${path.arrowX},${path.arrowY} ${path.arrowX - arrowSize * Math.cos(path.angle - Math.PI/6)},${path.arrowY - arrowSize * Math.sin(path.angle - Math.PI/6)} ${path.arrowX - arrowSize * Math.cos(path.angle + Math.PI/6)},${path.arrowY - arrowSize * Math.sin(path.angle + Math.PI/6)}`"
	  fill="black"/>
    </g>

    <g v-for="node in nodes" :key="`node-${node.id}`">
      <circle
	  :cx="node.x"
	  :cy="node.y"
	  :r="nodeRadius"
	  fill="white"
	  stroke="black"
	  stroke-width="2"
	  />
      <text
	  :x="node.x"
	  :y="node.y"
	  text-anchor="middle"
	  dominant-baseline="middle"
	  font-size="10"
	  >
	{{ node.title }}
      </text>
    </g>
  </svg>
</template>
