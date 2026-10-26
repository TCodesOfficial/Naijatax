# Chapter 4 (System Implementation and Documentation): Diagram Source Code (draw.io)

This file holds the draw.io code for every diagram in **Chapter 4 (System Implementation and Documentation)** of the NaijaTax Enlighten project report. Each code block is a complete, editable draw.io diagram.

All diagrams are sized for printing: when inserted at full text width (about 16 cm on A4), the smallest text prints at 8 pt or larger. Keep the image at full page width in Word so it stays readable.

## How to open a diagram in draw.io

**Option 1: paste the code (quickest)**

1. Open https://app.diagrams.net (or the draw.io desktop app) and create a **Blank Diagram**.
2. Go to **Extras → Edit Diagram**.
3. Delete everything in the box, paste the whole code block for the diagram you want (from `<mxfile` to `</mxfile>`) and click **OK**.

**Option 2: open it as a file**

1. Copy a code block into a new text file and save it with the extension **.drawio** (for example `use_case.drawio`).
2. In draw.io choose **File → Open from → Device** and pick the file.

**Putting an edited diagram back into Word:** in draw.io choose **File → Export as → PNG**, set **Zoom 200%** and **Border width 20**. In Word, right-click the old picture, choose **Change Picture → From a File**, and pick the new PNG. The caption stays in place. Make sure the picture still spans the full text width.

**Editing tips:** double-click any box or label to change its text. Keep font sizes at 19 or above so the printed text stays readable. Drag the yellow handles on an arrow to re-route it.

## Contents


- [Figure 4.1: Three-Tier Architecture](#figure-41-three-tier-architecture)
- [Figure 4.2: Program Modules](#figure-42-program-modules)
- [Figure 4.3: Input, Process and Output of the Tax Calculator](#figure-43-input-process-and-output-of-the-tax-calculator)
- [Figure 4.4: Context Diagram (Level 0 DFD)](#figure-44-context-diagram-level-0-dfd)
- [Figure 4.5: Level 1 Data Flow Diagram](#figure-45-level-1-data-flow-diagram)
- [Figure 4.14: Entity Relationship Diagram](#figure-414-entity-relationship-diagram)

---

## Figure 4.1 Three-Tier Architecture

Used in: 4.2.1 System Architecture

```xml
<mxfile host="drawio">
  <diagram id="fig4_1" name="Figure 4.1 System Architecture">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Three-Tier Architecture of NaijaTax Enlighten" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="940" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="PRESENTATION TIER" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#EEF4FF;strokeColor=#1F4E8C;strokeWidth=2.5;dashed=1;dashPattern=8 4;verticalAlign=top;align=left;spacingLeft=12;spacingTop=6;fontSize=22;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="940" height="170" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;NaijaTax Enlighten App&lt;/b&gt;&lt;br&gt;Flutter (Dart)&lt;br&gt;Android · iOS · Web" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=22;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="280" y="105" width="380" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="MIDDLE TIER (Business Logic)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#F1FAF0;strokeColor=#2E6B27;strokeWidth=2.5;dashed=1;dashPattern=8 4;verticalAlign=top;align=left;spacingLeft=12;spacingTop=6;fontSize=22;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="290" width="940" height="250" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="&lt;b&gt;REST API&lt;/b&gt;&lt;br&gt;Node.js · Express&lt;br&gt;TypeScript (on Render)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=22;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="30" y="350" width="450" height="120" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="&lt;b&gt;Supabase Auth&lt;/b&gt;&lt;br&gt;sign-in and sessions" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="620" y="340" width="290" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="&lt;b&gt;External Services&lt;/b&gt;&lt;br&gt;Gemini AI · news feeds" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="620" y="440" width="290" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="DATA TIER" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#FFF8EE;strokeColor=#9C5500;strokeWidth=2.5;dashed=1;dashPattern=8 4;verticalAlign=top;align=left;spacingLeft=12;spacingTop=6;fontSize=22;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="600" width="940" height="160" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="&lt;b&gt;PostgreSQL Database&lt;/b&gt;&lt;br&gt;(hosted on Supabase)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#9C5500;strokeWidth=2.5;fontSize=22;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="30" y="650" width="450" height="90" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="HTTPS / JSON" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.3;exitY=1;exitDx=0;exitDy=0;entryX=0.75;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c7">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="sign-in" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c8">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="765" y="160"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c14" value="AI, news" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=1;exitY=0.8;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c7" target="c9">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="550" y="446"/>
              <mxPoint x="550" y="480"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c15" value="SQL (Prisma)" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c7" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.2 Program Modules

Used in: 4.2.3 Program Modules

```xml
<mxfile host="drawio">
  <diagram id="fig4_2" name="Figure 4.2 Program Modules">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Program Modules of NaijaTax Enlighten" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="960" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="&lt;b&gt;CONTROL CENTRE&lt;/b&gt;&lt;br&gt;app shell · navigation · sign-in state" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#00288E;strokeColor=#00288E;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;fontColor=#FFFFFF;" vertex="1" parent="1">
          <mxGeometry x="230" y="55" width="500" height="85" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;1. Authentication&lt;/b&gt;&lt;br&gt;email, phone, Google · password reset · guest mode" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="185" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="237.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c7" value="&lt;b&gt;6. AI Assistant&lt;/b&gt;&lt;br&gt;tax questions · chat history" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="560" y="185" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c7">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="237.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c9" value="&lt;b&gt;2. Onboarding&lt;/b&gt;&lt;br&gt;short feature tour" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="315" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c9">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="367.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c11" value="&lt;b&gt;7. Community Forum&lt;/b&gt;&lt;br&gt;topics, replies and votes" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="560" y="315" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c11">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="367.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c13" value="&lt;b&gt;3. Dashboard&lt;/b&gt;&lt;br&gt;tax summary · news · inflation chart" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="445" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c13">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="497.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c15" value="&lt;b&gt;8. Learn &amp; Quiz&lt;/b&gt;&lt;br&gt;reform guide · quizzes" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="560" y="445" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c15">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="497.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c17" value="&lt;b&gt;4. Tax Calculator&lt;/b&gt;&lt;br&gt;income and company tax · statement upload · history and PDF" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="575" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c17">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="627.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c19" value="&lt;b&gt;9. Tax News&lt;/b&gt;&lt;br&gt;articles by category" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="560" y="575" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c19">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="627.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c21" value="&lt;b&gt;5. VAT Checker&lt;/b&gt;&lt;br&gt;search goods and services" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="705" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c21">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="757.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c23" value="&lt;b&gt;10. Profile&lt;/b&gt;&lt;br&gt;personal details · documents" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;spacingLeft=12;" vertex="1" parent="1">
          <mxGeometry x="560" y="705" width="400" height="105" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c23">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="480" y="757.5"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c25" value="&lt;b&gt;Server API&lt;/b&gt; (HTTPS):  /users · /tax · /ai · /forum · /quiz · /news" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="80" y="855" width="800" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;dashed=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c25">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.3 Input, Process and Output of the Tax Calculator

Used in: 4.2.4 Input and Output Formats

```xml
<mxfile host="drawio">
  <diagram id="fig4_3" name="Figure 4.3 Input-Process-Output">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Input, Process and Output of the Tax Calculator" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1000" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="&lt;b&gt;INPUT&lt;/b&gt;&lt;br&gt;• Monthly income&lt;br&gt;• Yearly rent paid&lt;br&gt;• Pension rate (8%)&lt;br&gt;• Business turnover and assets (optional)&lt;br&gt;• Bank statement (optional)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;verticalAlign=top;spacingLeft=10;spacingTop=8;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="290" height="330" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;PROCESS&lt;/b&gt;&lt;br&gt;• Check and annualise income&lt;br&gt;• Deduct pension and rent relief&lt;br&gt;• Apply NTA 2025 tax bands&lt;br&gt;• Classify company tax&lt;br&gt;• Save to history" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;verticalAlign=top;spacingLeft=10;spacingTop=8;" vertex="1" parent="1">
          <mxGeometry x="355" y="60" width="290" height="330" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="&lt;b&gt;OUTPUT&lt;/b&gt;&lt;br&gt;• Taxable income&lt;br&gt;• Tax payable and net income&lt;br&gt;• Breakdown by band&lt;br&gt;• Savings against the old law&lt;br&gt;• PDF report and charts" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;arcSize=8;align=left;verticalAlign=top;spacingLeft=10;spacingTop=8;" vertex="1" parent="1">
          <mxGeometry x="710" y="60" width="290" height="330" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="NTA 2025 bands: first ₦800k at 0% · next ₦2.2M at 15% · next ₦9M at 18% · next ₦13M at 21% · next ₦25M at 23% · above ₦50M at 25%" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=19;fontFamily=Helvetica;fontColor=#000000;align=center;fontStyle=2;" vertex="1" parent="1">
          <mxGeometry x="0" y="405" width="1000" height="60" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.4 Context Diagram (Level 0 DFD)

Used in: 4.2.6 Data Flow Diagrams

```xml
<mxfile host="drawio">
  <diagram id="fig4_4" name="Figure 4.4 Context Diagram">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Context Diagram (Level 0 DFD)" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1000" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="0&lt;br&gt;NaijaTax&lt;br&gt;Enlighten&lt;br&gt;System" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;fontSize=24;" vertex="1" parent="1">
          <mxGeometry x="390" y="230" width="220" height="220" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Registered&lt;br&gt;User" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="0" y="90" width="190" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Guest&lt;br&gt;User" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="0" y="520" width="190" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Supabase&lt;br&gt;Auth" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="810" y="90" width="190" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="AI Provider&lt;br&gt;(Gemini)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="810" y="300" width="190" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="News&lt;br&gt;Sources" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="810" y="520" width="190" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="income data,&lt;br&gt;questions, posts" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.3;exitDx=0;exitDy=0;entryX=0.15;entryY=0.15;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="300" y="114"/>
              <mxPoint x="300" y="263"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c11" value="results, reports,&lt;br&gt;AI answers, news" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="95" y="340"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c12" value="income data,&lt;br&gt;VAT search" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.3;exitDx=0;exitDy=0;entryX=0.15;entryY=0.85;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="300" y="544"/>
              <mxPoint x="300" y="417"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c13" value="tax estimate,&lt;br&gt;VAT status" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.75;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c6">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="500" y="580"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c14" value="credentials" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.7;exitY=0.04;exitDx=0;exitDy=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c7">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="544" y="110"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c15" value="session&lt;br&gt;token" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.75;exitDx=0;exitDy=0;entryX=0.93;entryY=0.25;entryDx=0;entryDy=0;" edge="1" parent="1" source="c7" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="690" y="150"/>
              <mxPoint x="690" y="285"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c16" value="question" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="answer" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.3;exitY=1;exitDx=0;exitDy=0;entryX=0.85;entryY=0.85;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="867" y="417"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c18" value="tax news" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0.65;entryY=0.97;entryDx=0;entryDy=0;" edge="1" parent="1" source="c9" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="533" y="560"/>
            </Array>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.5 Level 1 Data Flow Diagram

Used in: 4.2.6 Data Flow Diagrams

```xml
<mxfile host="drawio">
  <diagram id="fig4_5" name="Figure 4.5 Level 1 DFD">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Level 1 Data Flow Diagram" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1000" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="User&lt;br&gt;(Registered&lt;br&gt;or Guest)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="0" y="70" width="150" height="1135" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="1.0 Authenticate&lt;br&gt;User" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="70" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="credentials" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.02643171806167401;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="session" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.07048458149779736;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="D1 | Users" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="130" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Supabase&lt;br&gt;Auth" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="860" y="65" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.22;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="2.0 Compute&lt;br&gt;Tax" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="215" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="income data" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.15418502202643172;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="tax result" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.19823788546255505;entryDx=0;entryDy=0;" edge="1" parent="1" source="c12" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="D2 | Tax Profiles" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="275" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c12" target="c15">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="3.0 Check VAT&lt;br&gt;Status" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="360" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="item name" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.28193832599118945;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c17">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="VAT status" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.32599118942731276;entryDx=0;entryDy=0;" edge="1" parent="1" source="c17" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="D3 | VAT Items" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="420" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c17" target="c20">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="4.0 AI Tax&lt;br&gt;Assistant" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="505" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="question" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.40969162995594716;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c22">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="answer" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.45374449339207046;entryDx=0;entryDy=0;" edge="1" parent="1" source="c22" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="D4 | Chat Sessions" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="565" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c22" target="c25">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="AI&lt;br&gt;Provider" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="860" y="500" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.22;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c22" target="c27">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="5.0 Manage&lt;br&gt;Forum" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="650" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="topic, reply" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5374449339207048;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c29">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="discussions" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.5814977973568282;entryDx=0;entryDy=0;" edge="1" parent="1" source="c29" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="D5 | Forum Posts" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="710" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c29" target="c32">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="6.0 Run&lt;br&gt;Quiz" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="795" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="answers" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.6651982378854625;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c34">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c36" value="score" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.7092511013215859;entryDx=0;entryDy=0;" edge="1" parent="1" source="c34" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c37" value="D6 | Quiz Data" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="855" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c38" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c34" target="c37">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c39" value="7.0 Manage&lt;br&gt;Profile" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="940" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c40" value="profile edits" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.7929515418502202;exitDx=0;exitDy=0;entryX=0.03;entryY=0.33;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c39">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c41" value="profile" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.8370044052863436;entryDx=0;entryDy=0;" edge="1" parent="1" source="c39" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c42" value="D1 | Users" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="1000" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c43" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c39" target="c42">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c44" value="8.0 Collect and&lt;br&gt;Show News" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="330" y="1085" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c45" value="news" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.03;exitY=0.72;exitDx=0;exitDy=0;entryX=1;entryY=0.9647577092511013;entryDx=0;entryDy=0;" edge="1" parent="1" source="c44" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c46" value="D7 | Tax Articles" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="600" y="1145" width="230" height="50" as="geometry"/>
        </mxCell>
        <mxCell id="c47" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.78;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c44" target="c46">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c48" value="News&lt;br&gt;Sources" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="860" y="1080" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c49" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=none;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=block;startFill=1;exitX=0.93;exitY=0.22;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c44" target="c48">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c50" value="&lt;b&gt;Key:&lt;/b&gt;" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="1245" width="80" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c51" value="External entity" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#5B3A78;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;fontSize=20;" vertex="1" parent="1">
          <mxGeometry x="80" y="1235" width="210" height="55" as="geometry"/>
        </mxCell>
        <mxCell id="c52" value="Process" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;fontSize=20;" vertex="1" parent="1">
          <mxGeometry x="310" y="1230" width="170" height="65" as="geometry"/>
        </mxCell>
        <mxCell id="c53" value="Dn | Data store" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#000000;fontSize=20;" vertex="1" parent="1">
          <mxGeometry x="500" y="1240" width="200" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c54" value="" style="text;html=1;" vertex="1" parent="1">
          <mxGeometry x="730" y="1262" width="1" height="1" as="geometry"/>
        </mxCell>
        <mxCell id="c55" value="Data flow" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="860" y="1247" width="140" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="c56" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c54" target="c55">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.14 Entity Relationship Diagram

Used in: 4.4 Documentation (Data Dictionary)

```xml
<mxfile host="drawio">
  <diagram id="fig4_6" name="Figure 4.6 Entity Relationship Diagram">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Entity Relationship Diagram" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1110" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="tax_profiles" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="240" height="422" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;monthly_income&lt;br&gt;annual_gross&lt;br&gt;rent_paid&lt;br&gt;pension_rate&lt;br&gt;computed_tax&lt;br&gt;net_income&lt;br&gt;is_exempt&lt;br&gt;cit_exemption&lt;br&gt;turnover&lt;br&gt;assets&lt;br&gt;flat_rate&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="34" width="240" height="388" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="quiz_scores" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="560" width="240" height="179" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;score&lt;br&gt;total_questions&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c6">
          <mxGeometry x="0" y="34" width="240" height="145" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="users" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="290" y="60" width="240" height="287" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;email&lt;br&gt;phone&lt;br&gt;display_name&lt;br&gt;avatar_url&lt;br&gt;address&lt;br&gt;onboarded&lt;br&gt;role&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="34" width="240" height="253" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="chat_sessions" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="290" y="410" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;title&lt;br&gt;updated_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c10">
          <mxGeometry x="0" y="34" width="240" height="118" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="chat_messages" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="290" y="620" width="240" height="179" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; session_id&lt;br&gt;role&lt;br&gt;content&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="34" width="240" height="145" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="forum_topics" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="580" y="60" width="240" height="233" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;title&lt;br&gt;content&lt;br&gt;tags&lt;br&gt;up_votes&lt;br&gt;down_votes" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c14">
          <mxGeometry x="0" y="34" width="240" height="199" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="forum_replies" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="580" y="340" width="240" height="179" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; topic_id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;content&lt;br&gt;is_accepted" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="34" width="240" height="145" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="forum_votes" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="580" y="560" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; topic_id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;direction" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c18">
          <mxGeometry x="0" y="34" width="240" height="118" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="quiz_questions" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="870" y="60" width="240" height="179" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;question&lt;br&gt;options&lt;br&gt;correct_index&lt;br&gt;explanation" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="34" width="240" height="145" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="vat_items" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="870" y="300" width="240" height="179" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;name&lt;br&gt;category&lt;br&gt;status&lt;br&gt;rate" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c22">
          <mxGeometry x="0" y="34" width="240" height="145" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="tax_articles" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=34;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="870" y="540" width="240" height="233" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;title&lt;br&gt;summary&lt;br&gt;source&lt;br&gt;category&lt;br&gt;url&lt;br&gt;published_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=21;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c24">
          <mxGeometry x="0" y="34" width="240" height="199" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.25;exitDx=0;exitDy=0;entryX=1;entryY=0.1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.8;exitDx=0;exitDy=0;entryX=1;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c6">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="265" y="270"/>
              <mxPoint x="265" y="610"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c28" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.25;exitDx=0;exitDy=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.55;exitDx=0;exitDy=0;entryX=0;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c16">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="555" y="205"/>
              <mxPoint x="555" y="385"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c32" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.85;exitDx=0;exitDy=0;entryX=0;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c18">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="545" y="272"/>
              <mxPoint x="545" y="605"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c33" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c14" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;startSize=12;endSize=12;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.6;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c14" target="c18">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="845" y="195"/>
              <mxPoint x="845" y="630"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c35" value="Yellow: central table · Grey: reference tables · ─┼ one, ─&lt; many" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="800" width="1110" height="30" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```
