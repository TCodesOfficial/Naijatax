# Chapter 3 (Systems Analysis and Design): Diagram Source Code (draw.io)

This file holds the draw.io code for every diagram in **Chapter 3 (Systems Analysis and Design)** of the NaijaTax Enlighten project report. Each code block is a complete, editable draw.io diagram.

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


- [Figure 3.1: Use Case Diagram](#figure-31-use-case-diagram)
- [Figure 3.2: Activity Diagram: Opening the App and Signing In](#figure-32-activity-diagram-opening-the-app-and-signing-in)
- [Figure 3.3: Activity Diagram: Calculating Tax](#figure-33-activity-diagram-calculating-tax)
- [Figure 3.4: Activity Diagram: Asking the AI Tax Assistant](#figure-34-activity-diagram-asking-the-ai-tax-assistant)
- [Figure 3.5: Activity Diagram: Using the Community Forum](#figure-35-activity-diagram-using-the-community-forum)
- [Figure 3.6: Activity Diagram: Taking a Tax Quiz](#figure-36-activity-diagram-taking-a-tax-quiz)
- [Figure 3.7: Class Diagram (Part 1): User and Tax Models](#figure-37-class-diagram-part-1-user-and-tax-models)
- [Figure 3.8: Class Diagram (Part 2): Forum and Quiz Models](#figure-38-class-diagram-part-2-forum-and-quiz-models)
- [Figure 3.9: Class Diagram (Part 3): Services and State](#figure-39-class-diagram-part-3-services-and-state)
- [Figure 3.10: Sequence Diagram: Calculating Tax](#figure-310-sequence-diagram-calculating-tax)
- [Figure 3.11: Sequence Diagram: Asking the AI Tax Assistant](#figure-311-sequence-diagram-asking-the-ai-tax-assistant)
- [Figure 3.12: Entity Relationship Diagram](#figure-312-entity-relationship-diagram)

---

## Figure 3.1 Use Case Diagram

Used in: 3.2.2 Analysis of the Proposed System (I. Use Case Diagram)

```xml
<mxfile host="drawio">
  <diagram id="uc" name="Use Case Diagram">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Use Case Diagram of NaijaTax Enlighten" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1000" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="NaijaTax Enlighten" style="rounded=0;whiteSpace=wrap;html=1;fillColor=none;strokeColor=#222222;strokeWidth=3;verticalAlign=top;fontSize=22;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="170" y="55" width="660" height="905" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Available to everyone" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#EEF4FF;strokeColor=#1F4E8C;strokeWidth=2;verticalAlign=top;align=center;fontSize=20;fontStyle=1;spacingTop=4;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="190" y="100" width="620" height="330" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Calculate income tax" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="140" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Check company tax status" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="140" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="View NTA tax bands" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="212" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="Search VAT items" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="212" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Read tax news" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="284" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Read the reform guide" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="284" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Browse forum topics" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="356" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="Sign up or log in" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#1F4E8C;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="356" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="Registered users only" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#F1FAF0;strokeColor=#2E6B27;strokeWidth=2;verticalAlign=top;align=center;fontSize=20;fontStyle=1;spacingTop=4;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="190" y="450" width="620" height="495" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="Upload bank statement" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="490" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="View calculation history" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="490" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="Download PDF report" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="564" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="Chat with AI assistant" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="564" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="Post, reply and vote" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="638" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="Accept the best answer" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="638" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="Take quizzes" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="712" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="View quiz scores" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="712" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="Edit profile and photo" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="786" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="Store documents" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="786" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="Use biometric lock" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="205" y="860" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="Sign out" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2E6B27;strokeWidth=2;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="510" y="860" width="285" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="Guest User" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;strokeWidth=2.5;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="45" y="210" width="50" height="95" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="Registered&lt;br&gt;User" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;strokeWidth=2.5;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="45" y="640" width="50" height="95" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=none;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.4;exitDx=0;exitDy=0;entryX=0;entryY=0.4;entryDx=0;entryDy=0;" edge="1" parent="1" source="c27" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=none;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.4;exitDx=0;exitDy=0;entryX=0;entryY=0.4;entryDx=0;entryDy=0;" edge="1" parent="1" source="c28" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="inherits" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=0;endSize=16;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="70" y="638" as="sourcePoint"/>
            <mxPoint x="70" y="345" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c32" value="Supabase&lt;br&gt;Auth" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;strokeWidth=2.5;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="905" y="300" width="50" height="95" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="Gemini&lt;br&gt;AI" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;strokeWidth=2.5;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="905" y="640" width="50" height="95" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=none;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c13" target="c32">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=none;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.4;entryDx=0;entryDy=0;" edge="1" parent="1" source="c18" target="c33">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.2 Activity Diagram: Opening the App and Signing In

Used in: II. Activity Diagram

```xml
<mxfile host="drawio">
  <diagram id="act_signin" name="Activity - Signing in">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Activity Diagram: Opening the App and Signing In" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="960" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="" style="ellipse;html=1;fillColor=#000000;strokeColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="442" y="60" width="36" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Open the app" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="130" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Saved&lt;br&gt;session?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="228" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Show the landing page" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="368" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="Sign in or&lt;br&gt;guest?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="466" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="Enter email, phone&lt;br&gt;or Google account" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="606" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Details&lt;br&gt;valid?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="714" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Onboarding&lt;br&gt;done?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="914" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Open the dashboard" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="1054" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="440" y="1152" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="Continue as&lt;br&gt;a guest" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="0" y="589.0" width="240" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="Show an error&lt;br&gt;message" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="730.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="Show onboarding&lt;br&gt;once and save it" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="930.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c6" target="c7">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c7" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="[sign in]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c8" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="[guest]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c14">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="120" y="519.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c9" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c15">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c15" target="c9">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790.0" y="643.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c26" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c10" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c11">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="955" y="281.0"/>
              <mxPoint x="955" y="892"/>
              <mxPoint x="460" y="892"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c28" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c11" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c11" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c16" target="c12">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790.0" y="1086.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c31" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c14" target="c12">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="120" y="1086.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c32" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c12" target="c13">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.3 Activity Diagram: Calculating Tax

Used in: II. Activity Diagram

```xml
<mxfile host="drawio">
  <diagram id="act_tax" name="Activity - Calculating tax">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Activity Diagram: Calculating Tax" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="960" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="" style="ellipse;html=1;fillColor=#000000;strokeColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="442" y="60" width="36" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Open the tax calculator" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="126" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Upload a bank&lt;br&gt;statement?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="220" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Enter income, rent and&lt;br&gt;pension; tap Calculate" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="356" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="Inputs&lt;br&gt;valid?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="460" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="Server works out the tax:&lt;br&gt;deductions, NTA bands,&lt;br&gt;company tax" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="596" width="320" height="96" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Signed&lt;br&gt;in?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="722" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Show the result&lt;br&gt;and breakdown" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="858" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Download&lt;br&gt;PDF?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="962" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="440" y="1098" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="Upload the PDF; the&lt;br&gt;server fills the form" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="236.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="Show an error&lt;br&gt;message" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="476.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="Save the result&lt;br&gt;to history" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="738.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="Create the PDF&lt;br&gt;report" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="978.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c6" target="c7">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c14" target="c7">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790" y="378"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c7" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c15">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.75;exitY=0;exitDx=0;exitDy=0;entryX=1;entryY=0.7;entryDx=0;entryDy=0;" edge="1" parent="1" source="c15" target="c7">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="855" y="408"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c26" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c8" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c9" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c10" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c16" target="c11">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790.0" y="895.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c31" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c11" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c12" target="c13">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c12" target="c17">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c17" target="c13">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790" y="1118.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.4 Activity Diagram: Asking the AI Tax Assistant

Used in: II. Activity Diagram

```xml
<mxfile host="drawio">
  <diagram id="act_ai" name="Activity - AI assistant">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Activity Diagram: Asking the AI Tax Assistant" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="960" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="" style="ellipse;html=1;fillColor=#000000;strokeColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="442" y="60" width="36" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Signed&lt;br&gt;in?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="126" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Open AI Assistant; type&lt;br&gt;and send a question" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="262" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Existing&lt;br&gt;chat?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="366" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="Save the question" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="502" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="Load recent messages&lt;br&gt;and latest tax result" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="596" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Send to the&lt;br&gt;AI provider" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="700" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Answer&lt;br&gt;received?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="804" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Save and show&lt;br&gt;the answer" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="940" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="Another&lt;br&gt;question?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="1044" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="440" y="1180" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="Ask the user&lt;br&gt;to sign up" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="142.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="770" y="246.0" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="Create a new&lt;br&gt;chat session" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="382.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="Try the backup&lt;br&gt;provider (Groq)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="820.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c15">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c15" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c6" target="c7">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c7" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c7" target="c17">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c17" target="c8">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790.0" y="534.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c27" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c8" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c9" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c10" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c11" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c11" target="c18">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c18" target="c10">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="790.0" y="737.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c33" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c12" target="c13">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c13" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c13" target="c6">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="200" y="1097.0"/>
              <mxPoint x="200" y="299.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.5 Activity Diagram: Using the Community Forum

Used in: II. Activity Diagram

```xml
<mxfile host="drawio">
  <diagram id="act_forum" name="Activity - Forum">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Activity Diagram: Using the Community Forum" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="960" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="" style="ellipse;html=1;fillColor=#000000;strokeColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="442" y="60" width="36" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Open Community" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="130" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Browse or search&lt;br&gt;topics" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="228" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Open a topic" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="336" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="Post, reply&lt;br&gt;or vote?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="434" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="Signed&lt;br&gt;in?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="574" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Submit a post, reply,&lt;br&gt;vote or best answer" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="714" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Server saves it" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="822" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Refresh the topic" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="920" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="440" y="1018" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="Ask the user&lt;br&gt;to sign up" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="590.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="770" y="694.0" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c6" target="c7">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c7" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c8" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="[no, just&lt;br&gt;reading]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c13">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="150" y="487.0"/>
              <mxPoint x="150" y="1038.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c22" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c9" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c9" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c14" target="c15">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c10" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c11" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c12" target="c13">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.6 Activity Diagram: Taking a Tax Quiz

Used in: II. Activity Diagram

```xml
<mxfile host="drawio">
  <diagram id="act_quiz" name="Activity - Quiz">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Activity Diagram: Taking a Tax Quiz" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="960" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="" style="ellipse;html=1;fillColor=#000000;strokeColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="442" y="60" width="36" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Signed&lt;br&gt;in?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="130" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Load seven&lt;br&gt;questions" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="270" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Choose an answer" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="378" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="Server checks it and&lt;br&gt;shows the explanation" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="476" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="More&lt;br&gt;questions?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=19;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="335" y="584" width="250" height="106" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="Submit all answers" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="724" width="320" height="64" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Server grades and&lt;br&gt;saves the score" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="822" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Show the score&lt;br&gt;and grade" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="300" y="930" width="320" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="440" y="1038" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="Ask the user&lt;br&gt;to sign up" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#9C5500;strokeWidth=2.5;fontSize=20;fontFamily=Helvetica;fontColor=#000000;arcSize=8;arcSize=30;" vertex="1" parent="1">
          <mxGeometry x="660" y="146.0" width="260" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="" style="ellipse;html=1;shape=endState;fillColor=#000000;strokeColor=#000000;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="770" y="250.0" width="40" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c14" target="c15">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c6" target="c7">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c7" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c8" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="[no]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c9" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="[yes]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c9" target="c7">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="200" y="637.0"/>
              <mxPoint x="200" y="410.0"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c10" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c11" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1" source="c12" target="c13">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.7 Class Diagram (Part 1): User and Tax Models

Used in: 3.3.1 The Class Diagram

```xml
<mxfile host="drawio">
  <diagram id="class_models_tax" name="Class Diagram - User and Tax Models">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Class Diagram (Part 1): User and Tax Models" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1060" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="UserModel" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="300" height="324" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="- id: String&lt;br&gt;- email: String?&lt;br&gt;- phone: String?&lt;br&gt;- displayName: String?&lt;br&gt;- avatarUrl: String?&lt;br&gt;- address: String?&lt;br&gt;- role: String&lt;br&gt;- onboarded: bool&lt;br&gt;- createdAt: DateTime" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="36" width="300" height="244" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#1F4E8C;" vertex="1" parent="c4">
          <mxGeometry x="0" y="280" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="288" width="300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="TaxProfile" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="380" y="60" width="300" height="402" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="- monthlyIncome: double&lt;br&gt;- annualGross: double&lt;br&gt;- pensionDeduction: double&lt;br&gt;- rentRelief: double&lt;br&gt;- taxableIncome: double&lt;br&gt;- computedTax: double&lt;br&gt;- netIncome: double&lt;br&gt;- isExempt: bool&lt;br&gt;- citExemption: String&lt;br&gt;- savings: double&lt;br&gt;- breakdown: List" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="36" width="300" height="296" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#1F4E8C;" vertex="1" parent="c8">
          <mxGeometry x="0" y="332" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="+ fromJson(json)&lt;br&gt;+ effectiveTaxRate()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="340" width="300" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="TaxBreakdown" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="760" y="60" width="300" height="194" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="- bracket: String&lt;br&gt;- rate: double&lt;br&gt;- taxableAmount: double&lt;br&gt;- tax: double" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="36" width="300" height="114" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#1F4E8C;" vertex="1" parent="c12">
          <mxGeometry x="0" y="150" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="158" width="300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="InflationData" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="760" y="294" width="300" height="142" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="- year: int&lt;br&gt;- value: double" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="36" width="300" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#404040;" vertex="1" parent="c16">
          <mxGeometry x="0" y="98" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="106" width="300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="TaxArticle" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="424" width="300" height="298" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="- id: String&lt;br&gt;- title: String&lt;br&gt;- summary: String&lt;br&gt;- source: String&lt;br&gt;- category: String&lt;br&gt;- url: String?&lt;br&gt;- isFeatured: bool" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="36" width="300" height="192" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#404040;" vertex="1" parent="c20">
          <mxGeometry x="0" y="228" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="+ effectiveDate()&lt;br&gt;+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="236" width="300" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=diamondThin;startFill=1;startSize=18;endArrow=open;endSize=12;exitX=1;exitY=0.2;exitDx=0;exitDy=0;entryX=0;entryY=0.35;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="Key: ◆ filled diamond = contains (composition) · solid arrow = refers to · dashed arrow = uses" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=20;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="747" width="1060" height="34" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.8 Class Diagram (Part 2): Forum and Quiz Models

Used in: 3.3.1 The Class Diagram

```xml
<mxfile host="drawio">
  <diagram id="class_models_forum" name="Class Diagram - Forum and Quiz Models">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Class Diagram (Part 2): Forum and Quiz Models" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1060" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="ForumTopic" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="95" width="300" height="350" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="- id: String&lt;br&gt;- title: String&lt;br&gt;- content: String&lt;br&gt;- tags: List&lt;br&gt;- user: ForumUser&lt;br&gt;- replyCount: int&lt;br&gt;- upVotes: int&lt;br&gt;- downVotes: int&lt;br&gt;- replies: List" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="36" width="300" height="244" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c4">
          <mxGeometry x="0" y="280" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="+ score()&lt;br&gt;+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="288" width="300" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="ForumReply" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="380" y="95" width="300" height="220" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="- id: String&lt;br&gt;- content: String&lt;br&gt;- user: ForumUser&lt;br&gt;- isAccepted: bool&lt;br&gt;- createdAt: DateTime" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="36" width="300" height="140" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c8">
          <mxGeometry x="0" y="176" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="184" width="300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="ForumUser" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="760" y="95" width="300" height="194" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="- id: String&lt;br&gt;- displayName: String?&lt;br&gt;- avatarUrl: String?" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="36" width="300" height="88" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c12">
          <mxGeometry x="0" y="124" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="+ name()&lt;br&gt;+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="132" width="300" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="QuizQuestion" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="495" width="300" height="220" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="- id: String&lt;br&gt;- question: String&lt;br&gt;- options: List&lt;br&gt;- correctIndex: int?&lt;br&gt;- explanation: String?" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="36" width="300" height="140" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#8A6D00;" vertex="1" parent="c16">
          <mxGeometry x="0" y="176" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="184" width="300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="QuizAnswer" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="380" y="495" width="300" height="142" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="- questionId: String&lt;br&gt;- selectedIndex: int" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="36" width="300" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#8A6D00;" vertex="1" parent="c20">
          <mxGeometry x="0" y="98" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="+ toJson()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="106" width="300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="QuizScore" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#FFF2CC;strokeColor=#8A6D00;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="760" y="495" width="300" height="246" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="- id: String&lt;br&gt;- score: int&lt;br&gt;- totalQuestions: int&lt;br&gt;- createdAt: DateTime" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c24">
          <mxGeometry x="0" y="36" width="300" height="114" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#8A6D00;" vertex="1" parent="c24">
          <mxGeometry x="0" y="150" width="300" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="+ percentage()&lt;br&gt;+ grade()&lt;br&gt;+ fromJson(json)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c24">
          <mxGeometry x="0" y="158" width="300" height="88" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;startArrow=diamondThin;startFill=1;startSize=18;endArrow=open;endSize=12;exitX=1;exitY=0.25;exitDx=0;exitDy=0;entryX=0;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;endArrow=open;endSize=12;exitX=1;exitY=0.3;exitDx=0;exitDy=0;entryX=0;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;endArrow=open;endSize=12;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c12">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="150.0" y="70"/>
              <mxPoint x="910.0" y="70"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c31" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;dashed=1;endArrow=open;endSize=12;exitX=0;exitY=0.4;exitDx=0;exitDy=0;entryX=1;entryY=0.4;entryDx=0;entryDy=0;" edge="1" parent="1" source="c20" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="Key: ◆ filled diamond = contains (composition) · solid arrow = refers to · dashed arrow = uses" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=20;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="765" width="1060" height="34" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.9 Class Diagram (Part 3): Services and State

Used in: 3.3.1 The Class Diagram

```xml
<mxfile host="drawio">
  <diagram id="class_services" name="Class Diagram - Services and State">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Class Diagram (Part 3): Services and State" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1080" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="StorageService" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="340" height="402" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#404040;" vertex="1" parent="c4">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="+ init()&lt;br&gt;+ saveTaxProfile(profile)&lt;br&gt;+ getLatestTaxProfile()&lt;br&gt;+ addTaxCalculationToHistory()&lt;br&gt;+ getTaxCalculationHistory()&lt;br&gt;+ saveArticles(list)&lt;br&gt;+ getCachedArticles()&lt;br&gt;+ saveUserProfile(id, data)&lt;br&gt;+ setSetting(key, value)&lt;br&gt;+ getSetting(key)&lt;br&gt;+ clearAllUserData()&lt;br&gt;+ clearUserCache()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c4">
          <mxGeometry x="0" y="80" width="340" height="322" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="PdfService" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="492" width="340" height="142" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#404040;" vertex="1" parent="c8">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="+ generateTaxReportBytes()&lt;br&gt;+ exportTaxReport(profile)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c8">
          <mxGeometry x="0" y="80" width="340" height="62" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="BiometricService" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="664" width="340" height="168" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#404040;" vertex="1" parent="c12">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="+ isAvailable()&lt;br&gt;+ getAvailableBiometrics()&lt;br&gt;+ authenticate()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c12">
          <mxGeometry x="0" y="80" width="340" height="88" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="InflationService" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F2F2F2;strokeColor=#404040;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="862" width="340" height="116" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#404040;" vertex="1" parent="c16">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="+ fetchInflation(years)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c16">
          <mxGeometry x="0" y="80" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="ApiService" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="370" y="60" width="340" height="792" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="- dio: Dio" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#1F4E8C;" vertex="1" parent="c20">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="+ calculateTax(body)&lt;br&gt;+ getLatestTaxProfile()&lt;br&gt;+ getTaxHistory()&lt;br&gt;+ parseStatement(file)&lt;br&gt;+ searchVat(query, status)&lt;br&gt;+ sendChatMessage(text, id)&lt;br&gt;+ getChatSessions()&lt;br&gt;+ getSessionDetail(id)&lt;br&gt;+ deleteSession(id)&lt;br&gt;+ getTopics(tag, q)&lt;br&gt;+ getTopicDetail(id)&lt;br&gt;+ createTopic(title, text, tags)&lt;br&gt;+ createReply(id, text)&lt;br&gt;+ voteTopic(id, dir)&lt;br&gt;+ retractVote(id)&lt;br&gt;+ acceptReply(id)&lt;br&gt;+ getQuizQuestions()&lt;br&gt;+ checkQuizAnswer(id, i)&lt;br&gt;+ submitScore(answers)&lt;br&gt;+ getScoreHistory()&lt;br&gt;+ getPublicArticles()&lt;br&gt;+ getInflationData()&lt;br&gt;+ getMe()&lt;br&gt;+ updateProfile(...)&lt;br&gt;+ updateAvatar(url)&lt;br&gt;+ completeOnboarding()&lt;br&gt;+ getOnboardedStatus()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c20">
          <mxGeometry x="0" y="80" width="340" height="712" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="AuthNotifier" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="740" y="60" width="340" height="376" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="- state: AuthState" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c24">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c24">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="+ signInWithEmail()&lt;br&gt;+ signUpWithEmail()&lt;br&gt;+ signInWithPhone()&lt;br&gt;+ verifyOtp()&lt;br&gt;+ signInWithGoogle()&lt;br&gt;+ continueAsGuest()&lt;br&gt;+ sendPasswordResetOtp()&lt;br&gt;+ setNewPassword()&lt;br&gt;+ completeOnboarding()&lt;br&gt;+ fetchMe()&lt;br&gt;+ signOut()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c24">
          <mxGeometry x="0" y="80" width="340" height="296" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="TaxNotifier" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="740" y="466" width="340" height="194" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="- state: TaxState" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c28">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c28">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="+ calculate()&lt;br&gt;+ fetchFromServer()&lt;br&gt;+ fetchHistory()&lt;br&gt;+ reset()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c28">
          <mxGeometry x="0" y="80" width="340" height="114" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="ForumNotifier" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="740" y="690" width="340" height="220" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="- state: ForumState" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c32">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c32">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="+ fetchTopics()&lt;br&gt;+ addNewTopic()&lt;br&gt;+ replyToTopic()&lt;br&gt;+ voteTopic()&lt;br&gt;+ acceptReply()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c32">
          <mxGeometry x="0" y="80" width="340" height="140" as="geometry"/>
        </mxCell>
        <mxCell id="c36" value="QuizNotifier" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=36;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#D5E8D4;strokeColor=#2E6B27;strokeWidth=2.5;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="740" y="940" width="340" height="168" as="geometry"/>
        </mxCell>
        <mxCell id="c37" value="- state: QuizState" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c36">
          <mxGeometry x="0" y="36" width="340" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c38" value="" style="line;strokeWidth=2;fillColor=none;html=1;strokeColor=#2E6B27;" vertex="1" parent="c36">
          <mxGeometry x="0" y="72" width="340" height="8" as="geometry"/>
        </mxCell>
        <mxCell id="c39" value="+ fetchQuestions()&lt;br&gt;+ submitAnswers()&lt;br&gt;+ fetchScoreHistory()" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=20;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="c36">
          <mxGeometry x="0" y="80" width="340" height="88" as="geometry"/>
        </mxCell>
        <mxCell id="c40" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;dashed=1;endArrow=open;endSize=12;exitX=0;exitY=0.15;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c24" target="c20">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c41" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;dashed=1;endArrow=open;endSize=12;exitX=0;exitY=0.15;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c28" target="c20">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c42" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;dashed=1;endArrow=open;endSize=12;exitX=0;exitY=0.15;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c32" target="c20">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c43" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2.5;strokeColor=#222222;fontSize=19;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;dashed=1;endArrow=open;endSize=12;exitX=0;exitY=0.15;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c36" target="c20">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c44" value="Dashed arrows mean “uses”. Green: app state (Riverpod notifiers). Grey: on-device services." style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=21;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="1138" width="1080" height="60" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.10 Sequence Diagram: Calculating Tax

Used in: 3.3.2 The Sequence Diagram

```xml
<mxfile host="drawio">
  <diagram id="seq_tax" name="Sequence - Tax calculation">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Sequence Diagram: Calculating Tax" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1130" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="enter figures,&lt;br&gt;tap Calculate" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="85.0" y="138" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="80" y="200" as="sourcePoint"/>
            <mxPoint x="240" y="200" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c6" value="calculate(...)" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="245.0" y="208" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="240" y="270" as="sourcePoint"/>
            <mxPoint x="400" y="270" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c8" value="calculateTax()" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="405.0" y="278" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="340" as="sourcePoint"/>
            <mxPoint x="560" y="340" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c10" value="POST /tax/calculate" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="565.0" y="348" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="560" y="410" as="sourcePoint"/>
            <mxPoint x="720" y="410" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c12" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="720" y="480" as="sourcePoint"/>
            <mxPoint x="720" y="514" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="765" y="480"/>
              <mxPoint x="765" y="514"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c13" value="validate input" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="772" y="470" width="224.0" height="56" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="720" y="560" as="sourcePoint"/>
            <mxPoint x="720" y="594" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="765" y="560"/>
              <mxPoint x="765" y="594"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c15" value="apply NTA bands" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="772" y="550" width="224.0" height="56" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="save profile" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="725.0" y="648" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="720" y="710" as="sourcePoint"/>
            <mxPoint x="880" y="710" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c18" value="saved" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="725.0" y="718" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="880" y="780" as="sourcePoint"/>
            <mxPoint x="720" y="780" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c20" value="opt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=70;height=32;fontSize=21;fontStyle=1;strokeWidth=2;strokeColor=#555555;fillColor=none;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="645" y="610" width="310" height="200" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="[signed in]" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;fontStyle=2;" vertex="1" parent="1">
          <mxGeometry x="722" y="612" width="330" height="32" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="result (JSON)" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="565.0" y="828" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="720" y="890" as="sourcePoint"/>
            <mxPoint x="560" y="890" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c24" value="result" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="405.0" y="898" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="560" y="960" as="sourcePoint"/>
            <mxPoint x="400" y="960" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c26" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="1030" as="sourcePoint"/>
            <mxPoint x="400" y="1064" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="445" y="1030"/>
              <mxPoint x="445" y="1064"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c27" value="keep a copy&lt;br&gt;on the device" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="452" y="1020" width="224.0" height="56" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="new state" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="245.0" y="1048" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="1110" as="sourcePoint"/>
            <mxPoint x="240" y="1110" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c30" value="show result" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="85.0" y="1118" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="240" y="1180" as="sourcePoint"/>
            <mxPoint x="80" y="1180" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c32" value="tap Download&lt;br&gt;report" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="85.0" y="1188" width="150" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="80" y="1250" as="sourcePoint"/>
            <mxPoint x="240" y="1250" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c34" value="exportTaxReport(profile)" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="245.0" y="1258" width="790" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="240" y="1320" as="sourcePoint"/>
            <mxPoint x="1040" y="1320" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c36" value="PDF opens for saving or sharing" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="85.0" y="1328" width="950" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c37" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="1040" y="1390" as="sourcePoint"/>
            <mxPoint x="80" y="1390" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c38" value="User" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="7.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c39" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="80" y="134" as="sourcePoint"/>
            <mxPoint x="80" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c40" value="Calculator&lt;br&gt;Screen" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="167.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c41" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="240" y="134" as="sourcePoint"/>
            <mxPoint x="240" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c42" value="TaxNotifier" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="327.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c43" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="134" as="sourcePoint"/>
            <mxPoint x="400" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c44" value="ApiService" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="487.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c45" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="560" y="134" as="sourcePoint"/>
            <mxPoint x="560" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c46" value="Tax API&lt;br&gt;(Express)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="647.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c47" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="720" y="134" as="sourcePoint"/>
            <mxPoint x="720" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c48" value="PostgreSQL" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="807.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c49" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="880" y="134" as="sourcePoint"/>
            <mxPoint x="880" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c50" value="PdfService" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="967.0" y="60" width="146" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c51" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="1040" y="134" as="sourcePoint"/>
            <mxPoint x="1040" y="1470" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.11 Sequence Diagram: Asking the AI Tax Assistant

Used in: 3.3.2 The Sequence Diagram

```xml
<mxfile host="drawio">
  <diagram id="seq_ai" name="Sequence - AI chat">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Sequence Diagram: Asking the AI Tax Assistant" style="text;html=1;align=center;verticalAlign=middle;fontSize=26;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1090" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="type and send&lt;br&gt;a question" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="85.0" y="138" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="80" y="200" as="sourcePoint"/>
            <mxPoint x="265" y="200" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c6" value="sendChat&lt;br&gt;Message()" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="270.0" y="208" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="265" y="270" as="sourcePoint"/>
            <mxPoint x="450" y="270" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c8" value="POST /ai/message" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="455.0" y="278" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="450" y="340" as="sourcePoint"/>
            <mxPoint x="635" y="340" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c10" value="create session" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="418" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="480" as="sourcePoint"/>
            <mxPoint x="820" y="480" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c12" value="new session" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="488" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="820" y="550" as="sourcePoint"/>
            <mxPoint x="635" y="550" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c14" value="opt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=70;height=32;fontSize=21;fontStyle=1;strokeWidth=2;strokeColor=#555555;fillColor=none;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="560" y="380" width="335" height="200" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="[first message]" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;fontStyle=2;" vertex="1" parent="1">
          <mxGeometry x="637" y="382" width="330" height="32" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="save question" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="598" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="660" as="sourcePoint"/>
            <mxPoint x="820" y="660" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c18" value="load history&lt;br&gt;and tax results" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="668" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="730" as="sourcePoint"/>
            <mxPoint x="820" y="730" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c20" value="history" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="738" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="820" y="800" as="sourcePoint"/>
            <mxPoint x="635" y="800" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c22" value="prompt + history" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="808" width="360" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="870" as="sourcePoint"/>
            <mxPoint x="1005" y="870" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c24" value="answer" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="878" width="360" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="1005" y="940" as="sourcePoint"/>
            <mxPoint x="635" y="940" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c26" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="1080" as="sourcePoint"/>
            <mxPoint x="635" y="1114" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="680" y="1080"/>
              <mxPoint x="680" y="1114"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c27" value="retry with backup&lt;br&gt;provider (Groq)" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="687" y="1070" width="259.0" height="56" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="opt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=70;height=32;fontSize=21;fontStyle=1;strokeWidth=2;strokeColor=#555555;fillColor=none;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="560" y="980" width="520" height="140" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="[provider busy]" style="text;html=1;align=left;verticalAlign=middle;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;fontStyle=2;" vertex="1" parent="1">
          <mxGeometry x="637" y="982" width="330" height="32" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="save answer" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="640.0" y="1138" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="" style="html=1;strokeWidth=2.5;strokeColor=#222222;endArrow=block;endFill=1;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="1200" as="sourcePoint"/>
            <mxPoint x="820" y="1200" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c32" value="answer + session" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="455.0" y="1208" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="1270" as="sourcePoint"/>
            <mxPoint x="450" y="1270" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c34" value="reply" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="270.0" y="1278" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="450" y="1340" as="sourcePoint"/>
            <mxPoint x="265" y="1340" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c36" value="show the answer" style="text;html=1;align=center;verticalAlign=bottom;whiteSpace=wrap;fontSize=21;spacingBottom=2;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="85.0" y="1348" width="175" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c37" value="" style="html=1;strokeWidth=2;strokeColor=#222222;dashed=1;endArrow=open;endSize=12;fontSize=21;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#000000;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="265" y="1410" as="sourcePoint"/>
            <mxPoint x="80" y="1410" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c38" value="User" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="-5.5" y="60" width="171" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c39" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="80" y="134" as="sourcePoint"/>
            <mxPoint x="80" y="1490" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c40" value="Chat Screen" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="179.5" y="60" width="171" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c41" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="265" y="134" as="sourcePoint"/>
            <mxPoint x="265" y="1490" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c42" value="ApiService" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="364.5" y="60" width="171" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c43" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="450" y="134" as="sourcePoint"/>
            <mxPoint x="450" y="1490" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c44" value="AI API&lt;br&gt;(Express)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="549.5" y="60" width="171" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c45" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="635" y="134" as="sourcePoint"/>
            <mxPoint x="635" y="1490" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c46" value="PostgreSQL" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="734.5" y="60" width="171" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c47" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="820" y="134" as="sourcePoint"/>
            <mxPoint x="820" y="1490" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="c48" value="Gemini AI" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#1F4E8C;strokeWidth=2.5;fontSize=21;fontStyle=1;fontFamily=Helvetica;fontColor=#000000;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="919.5" y="60" width="171" height="74" as="geometry"/>
        </mxCell>
        <mxCell id="c49" value="" style="html=1;endArrow=none;dashed=1;strokeWidth=2;strokeColor=#555555;" edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="1005" y="134" as="sourcePoint"/>
            <mxPoint x="1005" y="1490" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 3.12 Entity Relationship Diagram

Used in: 3.3.3 The Database Design

```xml
<mxfile host="drawio">
  <diagram id="erd" name="Entity Relationship Diagram">
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
