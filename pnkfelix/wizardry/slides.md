## Talk outline

* Developer humor
* Software delivery cycle
* Schools of thought on debugging
* The scientific method
* Zooming in on observation and analysis
* Tools

---





```mermaid
graph LR
    Problem(["Problem"])
    Spec(["Specification"])
    Test(["Testing"])
    Impl(["Implementation"])
    Delivery(["Delivery"])

    Problem --> Spec
    Spec --> Impl
	Impl --> Test
	Test --> Delivery
	Delivery --> Problem
```	

---
layout: two-cols
clicks: 5
---


<style>
.highlighted-problem #Problem { fill: #ff9900 !important; stroke: #ff6600 !important; stroke-width: 2px !important; }
.highlighted-spec #Spec { fill: #ff9900 !important; stroke: #ff6600 !important; stroke-width: 2px !important; }
.highlighted-impl #Impl { fill: #ff9900 !important; stroke: #ff6600 !important; stroke-width: 2px !important; }
.highlighted-test #Test { fill: #ff9900 !important; stroke: #ff6600 !important; stroke-width: 2px !important; }
.highlighted-delivery #Delivery { fill: #ff9900 !important; stroke: #ff6600 !important; stroke-width: 2px !important; }
</style>

<div :class="{ 'highlighted-problem': $clicks === 1, 'highlighted-spec': $clicks === 2, 'highlighted-impl': $clicks === 3, 'highlighted-test': $clicks === 4, 'highlighted-delivery': $clicks === 5 }">
```mermaid
graph TD
    Problem(["Problem"])
    Delivery(["Delivery"])
    Spec(["Specification"])
    Test(["Testing"])
    Impl(["Implementation"])
    Invis([" "])

	Problem dp@-.- Delivery
    Problem ps@-.- Spec
    Spec si@-.- Impl
	Delivery td@-.- Test
	Test -.- Invis
	Impl -.- Invis

    classDef problem rx:20
    classDef spec rx:20
    classDef impl rx:20
    classDef test rx:20
    classDef delivery rx:20
    classDef invisible width:0px,height:0px,fill:none,color:none,stroke:none
	
    class Problem problem
    class Spec spec
    class Impl impl
    class Test test
    class Delivery delivery
	class Invis invisible
```
</div>


::right::

here is some text

<div>
  <div v-if="$clicks === 1">
    <p>Discussing the problem...</p>
  </div>
  <div v-else-if="$clicks === 2">
    <p>Creating the specification...</p>
  </div>
  <div v-else-if="$clicks === 3">
    <p>Implementing the solution...</p>
  </div>
  <div v-else-if="$clicks === 4">
    <p>Testing our implementation...</p>
  </div>
  <div v-else-if="$clicks === 5">
    <p>Delivering the product...</p>
  </div>
</div>

---

<svg>
 <g transform="translate(50,50)">
  <rect width=60 height=40 rx=20 ry=20 fill="white" class="black1" />
  <text class="middle_text">Spec</text>
</g>
</svg>

---

```mermaid
graph TB
  Need --- Ship
  Ship --- Test
  Spec --- Impl
  Invis([" "])
  Impl --- Invis
  Test --- Invis

  class Invis invisible
%%  linkStyle 0,2 stroke:
  classDef invisible width:0px,height:0px,fill:none,color:none,stroke:none
```

---

```mermaid
graph LR
  Need
  subgraph LEFT
     direction BT
	   Test --> Ship
  end
  LEFT ~~~ RIGHT
  subgraph RIGHT
     direction TB
	    Spec --> Impl
  end
```

---



---

Hello World

<svg xmlns="http://www.w3.org/2000/svg" width="500" height="150" viewBox="0 0 500 150" style="background-color: white;">
  <style>
  .black1 { stroke: black; stroke-width: 1 }
  .sibling {
    stroke: orange; stroke-width: 1; fill: none;
  }
  .child {
    stroke: blue; stroke-width: 1; fill: none;
  }
  .middle_text {
    text-anchor: middle; dominant-baseline: middle
  }
  </style>
  <!-- Links -->
  <!-- Sibling links (horizontal) -->
  <path d="M 70 75 L 170 75" class="sibling" />
  <path d="M 170 75 L 270 75" class="sibling" />
  <path d="M 70 125 L 170 125" class="sibling" />
  <path d="M 170 125 L 270 125" class="sibling" />
  
  <!-- Child links -->
  <path d="M 40 75 L 40 100 L 70 125" class="child" />
  <path d="M 170 75 L 170 125" class="child" />
  <path d="M 270 75 L 270 100 L 370 125" class="child" />
  
  <!-- Nodes -->
  <!-- First row -->
  <g transform="translate(40, 75)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">A</text>
  </g>
  
  <g transform="translate(75, 75)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">B</text>
  </g>

  <g transform="translate(170, 75)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">C</text>
  </g>
  
  <g transform="translate(270, 75)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">D</text>
  </g>
  
  <!-- Second row -->
  <g transform="translate(70, 125)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">E</text>
  </g>
  
  <g transform="translate(170, 125)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">F</text>
  </g>

  <g transform="translate(270, 125)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">G</text>
  </g>
  
  <g transform="translate(370, 125)">
    <circle r="15" fill="white" class="black1" />
    <text class="middle_text">H</text>
  </g>
</svg>

Helow

---
src: ./deeper.naive_svg.xml
---

---
src: ./sect_2_3_2.naive_svg.xml
---

---
---

Ji 0

<img src="./tree1.svg"/>


---

Ji 1

<<< ./tree1.svg xml

---

Ji 2

<<< ./tree1.svg xml

---

Ji

---
src: guide.md
---
